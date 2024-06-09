import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media/comment_tile_widget.dart';
import 'package:social_media/main.dart';
import 'package:social_media/post_page.dart';
import 'package:social_media/profile_page.dart';
import 'package:social_media/services/post_service.dart';

class PostWidget extends StatefulWidget {
  final String? description;
  final String? image;
  final String? user;
  final String? postid;
  final int? likes;
  final int? comments;
  final Timestamp createdAt;

  const PostWidget(
      {super.key,
      this.description,
      this.image,
      this.user,
      this.postid,
      this.likes,
      this.comments,
      required this.createdAt});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  final _postService = locator<PostService>();
  bool _isLiked = false;
  bool _isFollowing = false;
  int likeCounts = 0;
  int commentsCount = 0;
  final _formkey = GlobalKey<FormState>();
  List<Map<String, dynamic>> comments = [];

  TextEditingController commentController = TextEditingController();

  final userId = FirebaseAuth.instance.currentUser!.uid;

  getLike() async {
    final likebool =
        await _postService.isliked(userId: userId, postId: widget.postid);
    _isLiked = likebool ? true : false;
  }

  getFollow() async {
    final followbool =
        await _postService.isFollowing(user: userId, author: widget.user);
    _isFollowing = followbool ? true : false;
  }

  getLikeCounts() {
    setState(() {
      likeCounts = widget.likes!;
    });
  }

  getComments() async {
    comments = await _postService.getComments(postId: widget.postid);
    setState(() {});
  }

  getCommentCounts() {
    setState(() {
      commentsCount = widget.comments!;
    });
  }

  @override
  initState() {
    super.initState();
    getLike();
    getLikeCounts();
    getCommentCounts();
    getComments();
    getFollow();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _postService.getUserDetails(widget.user),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(userId: snapshot.data?['id'])));
                    },
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    snapshot.data?['profileImage'] != null
                                      ? CachedNetworkImageProvider(snapshot.data?['profileImage']!)
                                      : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: Colors.white, width: 2)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.data?['name']!,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 5),
                            Text(GetTimeAgo.parse(widget.createdAt.toDate()),
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xff919191)))
                          ],
                        ),
                        const Spacer(),
                        if (snapshot.data?['id'] != currentUser)
                          TextButton(
                            style: _isFollowing
                                ? ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    side: MaterialStateProperty.all(
                                        const BorderSide(
                                            color: Color(0xffEEEEEE))),
                                  )
                                : ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xff40D463)),
                                    side: MaterialStateProperty.all(
                                        const BorderSide(
                                            color: Color(0xff40D463))),
                                  ),
                            onPressed: () {
                              if (!_isFollowing) {
                                setState(() {
                                  _postService.follow(
                                      user: userId,
                                      author: snapshot.data?['id']);
                                  _isFollowing = true;
                                });
                              } else {
                                setState(() {
                                  _postService.unfollow(
                                      user: userId,
                                      author: snapshot.data?['id']);
                                  _isFollowing = false;
                                });
                              }
                            },
                            child: _isFollowing
                                ? const Text("Following",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600))
                                : const Text("Follow",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostPage(
                                  postid: widget.postid,
                                  user: widget.user,
                                  description: widget.description,
                                  image: widget.image,
                                  likes: likeCounts,
                                  comments: commentsCount,
                                  refershPage: (){
                                    getLike();
                                    getLikeCounts();
                                  }
                                  )));
                    },
                    child: Container(
                      height: 281,
                      width: 345,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: widget.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: widget.image.toString(),
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        ),
                                  ),
                                ),
                              ))
                          : const Center(child: Text('No Image')),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(widget.description!,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xff919191))),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined,
                            color: Color(0xff0F393A)),
                      ),
                      const Text('36'),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (_isLiked) {
                            _postService.unlikePost(
                                userId: userId, postId: widget.postid);
                          } else {
                            _postService.likePost(
                                userId: userId, postId: widget.postid);
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
                                color: Color(0xff0F393A)),
                      ),
                      GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Likes',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(height: 10),
                                          FutureBuilder(
                                            future: _postService
                                                .getLikedUsers(widget.postid),
                                            builder: (context,
                                                AsyncSnapshot<List> snapshot) {
                                              if (snapshot.hasData) {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      snapshot.data?.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                        leading: CircleAvatar(
                                                          radius: 20,
                                                          backgroundImage: snapshot
                                                                              .data![
                                                                          index]
                                                                      [
                                                                      'profileImage'] !=
                                                                  null
                                                              ? CachedNetworkImageProvider(snapshot.data![index]['profileImage'].toString())
                                                              // ? Image.network(snapshot
                                                              //                 .data![
                                                              //             index]
                                                              //         [
                                                              //         'profileImage'])
                                                              //     .image
                                                              : null,
                                                        ),
                                                        title: Text(snapshot
                                                                .data![index]
                                                            ['name']));
                                                  },
                                                );
                                              } else {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text(likeCounts.toString())),
                      const SizedBox(width: 15),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            useSafeArea: true,
                            isScrollControlled: true,
                            enableDrag: true,
                            showDragHandle: true,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: StatefulBuilder(
                                    builder: (context, setStateForBuilder) {
                                  return Container(
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Stack(
                                        children: [
                                          const SizedBox(height: 10),
                                          ListView.builder(
                                            padding: const EdgeInsets.only(
                                                bottom: 100),
                                            itemCount: comments.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return CommentTileWidget(
                                                comment: comments[index]
                                                    ['comment'],
                                                userId: comments[index]
                                                    ['userId'],
                                                createdAt: comments[index]
                                                    ['createdAt'],
                                                postid: widget.postid,
                                                commentid: comments[index]
                                                    ['id'],
                                                onDelete: (id) {
                                                  comments.removeWhere(
                                                      (element) =>
                                                          element['id'] == id);
                                                  setState(() {
                                                    commentsCount--;
                                                  });
                                                  setStateForBuilder(() {});
                                                },
                                              );
                                            },
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            child: Container(
                                              color: Colors.white,
                                              child: Form(
                                                key: _formkey,
                                                child: Center(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            40,
                                                        child: TextField(
                                                          controller:
                                                              commentController,
                                                          decoration: const InputDecoration(
                                                              hintText:
                                                                  'Add a comment',
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(
                                                                          10)),
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          45,
                                                                          210,
                                                                          90))),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                  borderSide:
                                                                      BorderSide(color: Color(0xffeeeeee)))),
                                                        ),
                                                      ),
                                                      TextButton(
                                                          onPressed: () async {
                                                            final commentMessage =
                                                                commentController
                                                                    .text;

                                                            commentController
                                                                .clear();
                                                            var commentId = await _postService
                                                                .postComment(
                                                                    userId:
                                                                        userId,
                                                                    postId: widget
                                                                        .postid,
                                                                    message:
                                                                        commentMessage);
                                                            setStateForBuilder(
                                                                () {
                                                              commentsCount++;
                                                              comments.add({
                                                                'userId':
                                                                    userId,
                                                                'comment':
                                                                    commentMessage,
                                                                'id': commentId,
                                                                'createdAt':
                                                                    Timestamp
                                                                        .now(),
                                                              });
                                                            });
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .green),
                                                              shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)))),
                                                          child: const Text(
                                                            'ADD',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          );
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/CommentIcon.svg',
                          height: 19,
                        ),
                      ),
                      Text(commentsCount.toString()),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              color: Colors.white, width: 2)),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 15,
                                    width: 100,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    height: 10,
                                    width: 100,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Container(
                            height: 281,
                            width: 345,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Container(
                            height: 10,
                            width: 345,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              const Icon(Icons.share_outlined,
                                  color: Color(0xff0F393A)),
                              const SizedBox(width: 8),
                              Container(
                                height: 10,
                                width: 20,
                                color: Colors.grey,
                              ),
                              const Spacer(),
                              const Icon(Icons.favorite_border,
                                  color: Color(0xff0F393A)),
                              const SizedBox(width: 8),
                              Container(
                                height: 10,
                                width: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 20),
                              SvgPicture.asset(
                                'assets/icons/CommentIcon.svg',
                                height: 19,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 10,
                                width: 20,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ])));
          }
        });
  }
}
