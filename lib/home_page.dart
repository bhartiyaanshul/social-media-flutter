import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_media/confirm_box.dart';
import 'package:social_media/create_post.dart';
import 'package:social_media/main.dart';
import 'package:social_media/post_widget.dart';
import 'package:social_media/profile_page.dart';
import 'package:social_media/services/auth_services.dart';
import 'package:social_media/services/post_service.dart';
import 'package:social_media/signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = locator<AuthService>();
  final _postService = locator<PostService>();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> posts = [];
  Map<String, dynamic>? users = {};

  getPosts() async {
    posts = await _postService.getPosts();
    setState(() {});
  }

  Future<void> _refreshData() async { 
    await Future.delayed(Duration(milliseconds: 1000)); 
      getPosts();
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreatePost()));
            },
            icon: SvgPicture.asset('assets/icons/Camera.svg')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.logout_rounded, size: 28),
                  onPressed: () async {
                    final rs = await showDialog(
                      context: context,
                      builder: (context){
                        return const ConfirmBox(action: 'logout ');
                      }
                    );
                    if(rs == true){
                      await _auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage())
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person_outlined, size: 28),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(userId: currentUserId)));
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: Center(
          child: RefreshIndicator(
            onRefresh: () => getPosts(),
            child: ListView.separated(
                cacheExtent: 2000,
                itemCount: posts.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                    child: PostWidget(
                      description: post['description'],
                      image: post['postImage'],
                      user: post['createdBy'],
                      postid: post['id'],
                      likes: post['likesCount'],
                      comments: post['commentsCount'] ?? 0,
                      createdAt: post['createdAt']
                    ),
                  );
                }),
          )),
    );
  }
}
