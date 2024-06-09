import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_media/main.dart';
import 'package:social_media/services/post_service.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  final _postService = locator<PostService>();
  bool _isFollowing = false;
  Map<String, dynamic>? userDetails = {};
  List<Map<String, dynamic>> posts = [];

  getUserPosts() async {
    var postsdata = await _postService.getUserPosts(userId: widget.userId);
    setState(() {
      posts = postsdata;
    });
  }

  getFollow() async {
    final followbool = await _postService.isFollowing(
        user: currentUser, author: widget.userId);
    _isFollowing = followbool ? true : false;
  }

  getUserDetails() async {
    userDetails = await _postService.getUserDetails(widget.userId);
    setState(() {
      userDetails = userDetails;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getUserPosts();
    getFollow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
            child: Text(
          'Profile',
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600),
        )),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline_sharp),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_outlined),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(color: Color(0xffEEEEEE)),
              const SizedBox(height: 28),
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey,
                backgroundImage: userDetails?['profileImage'] != null
                    ? CachedNetworkImageProvider(userDetails?['profileImage']!)
                    // ? Image.network(userDetails?['profileImage']!).image
                    : null,
              ),
              const SizedBox(height: 20),
              Text(
                userDetails?['name'] ?? '',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Text(
                userDetails?['username'] ?? '',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Color(0xff919191)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xffBEBEBE),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xffBEBEBE),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xffBEBEBE),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xffBEBEBE),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 130,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: const Color(0xffEEEEEE)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              color: const Color(0xffF6F5EE),
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                          child: Container(
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        SvgPicture.asset('assets/icons/CommentIcon.svg'),
                        const SizedBox(width: 10),
                        const Text(
                          'Message',
                          style: TextStyle(
                              color: Color(0xff626262),
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  if (widget.userId != currentUser) ...[
                    const SizedBox(width: 15),
                    TextButton(
                      style: _isFollowing
                          ? ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              side: MaterialStateProperty.all(
                                  const BorderSide(color: Color(0xffEEEEEE))),
                            )
                          : ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(const Color(0xff40D463)),
                              side: MaterialStateProperty.all(
                                  const BorderSide(color: Color(0xff40D463))),
                            ),
                      onPressed: () {
                        if (!_isFollowing) {
                          setState(() {
                            _postService.follow(
                                user: currentUser, author: widget.userId);
                            _isFollowing = true;
                          });
                        } else {
                          setState(() {
                            _postService.unfollow(
                                user: currentUser, author: widget.userId);
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
                  ]
                  // IconButton.outlined(
                  //   onPressed: (){},
                  //   icon: SvgPicture.asset('assets/icons/CommentIcon.svg'),
                  // )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffEEEEEE)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userDetails!['follower']?.toString() ?? '0',
                          style: const TextStyle(
                              color: Color(0xff1d1d20),
                              fontFamily: 'Poppins',
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          'Followers',
                          style: TextStyle(
                              color: Color(0xff919191),
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 28),
                  Container(
                    width: 90,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffEEEEEE)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userDetails!['postsCount']?.toString() ?? '0',
                          style: const TextStyle(
                              color: Color(0xff1d1d20),
                              fontFamily: 'Poppins',
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          'Posts',
                          style: TextStyle(
                              color: Color(0xff919191),
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 28),
                  Container(
                    width: 90,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xffEEEEEE)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userDetails!['following']?.toString() ?? '0',
                          style: const TextStyle(
                              color: Color(0xff1d1d20),
                              fontFamily: 'Poppins',
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          'Following',
                          style: TextStyle(
                              color: Color(0xff919191),
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Divider(color: Color(0xffEEEEEE)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    cacheExtent: 2000,
                    scrollDirection: Axis.horizontal,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: SizedBox(
                          height: 180,
                          child: post['postImage'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child : CachedNetworkImage(
                                            imageUrl: post['postImage'].toString(),
                                          ))
                                  // child: Image.network(post['postImage']!,
                                  //     fit: BoxFit.fill))
                              : const Center(child: Text('No Image')),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
