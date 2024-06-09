import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_media/comment_tile_widget.dart';
import 'package:social_media/main.dart';
import 'package:social_media/services/post_service.dart';

class PostPage extends StatefulWidget {
  final String? postid;
  final String? user;
  final String? description;
  final String? image;
  final int? comments;
  final int? likes;
  final Function() refershPage;
  const PostPage({
    super.key,
    required this.postid,
    required this.user,
    required this.description,
    required this.image,
    required this.comments,
    required this.likes,
    required this.refershPage,
  });
  
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  final _postService = locator<PostService>();
  List<Map<String, dynamic>> comments = [];
  bool _isLiked = false;
  int likeCounts = 0;

  getComments() async {
    final commentsData = await _postService.getComments(postId: widget.postid);
    setState(() {
      comments = commentsData;
    });
  }

  getLike() async {
    final likebool =
        await _postService.isliked(userId: currentUser, postId: widget.postid);
    _isLiked = likebool ? true : false;
    print(likebool);
  }

  getLikeCounts() {
    setState(() {
      likeCounts = widget.likes!;
    });
  }

  @override
  void initState() {
    super.initState();
    getComments();
    getLike();
    getLikeCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: widget.image != null
                    ? CachedNetworkImage(
                        imageUrl: widget.image.toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                ),
                          ),
                        ),
                      ) 
                    : const Center(child: Text('No Image')),
              ),
              SafeArea(
                child: Row(
                  children: [
                    const SizedBox(width: 10,),
                    IconButton(
                      onPressed: () async {
                        widget.refershPage();
                        Navigator.pop(context);
                      },
                      icon: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xff28CD56).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white,)
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: (){}, 
                      icon: const Icon(Icons.more_vert, color: Colors.white,)
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 10,),
                      IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.share_outlined),
                        color: Colors.white,
                      ),
                      const Text('8', style: TextStyle(fontSize: 14, color: Colors.white),),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (_isLiked) {
                            _postService.unlikePost(
                                userId: currentUser, postId: widget.postid);
                          } else {
                            _postService.likePost(
                                userId: currentUser, postId: widget.postid);
                          }
                          setState(() {
                            if (!_isLiked) {
                              _isLiked = true;
                              likeCounts++;
                            } else {
                              _isLiked = false;
                              likeCounts--;
                            }
                          });
                        },
                        icon: _isLiked
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : const Icon(Icons.favorite_border,
                                color: Colors.white),
                      ),
                      Text(likeCounts.toString(), style: const TextStyle(fontSize: 14, color: Colors.white),),
                      IconButton(
                        onPressed: () {
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/CommentIconLight.svg',
                          height: 19,
                        ),
                        color: Colors.white,
                      ),
                      Text(widget.comments.toString(), style: const TextStyle(fontSize: 14, color: Colors.white),),
                      const SizedBox(width: 25,)
                    ],
                  ),
                ),
              ),
            ]
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.description!,
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  color: Color(0xff1A1B23)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentTileWidget(
                  comment: comments[index]['comment'],
                  userId: comments[index]['userId'],
                  createdAt: comments[index]['createdAt'],
                  postid: widget.postid,
                  commentid: comments[index]['id'],
                  onDelete: (id) {
                    comments.removeWhere((element) => element['id'] == id);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
