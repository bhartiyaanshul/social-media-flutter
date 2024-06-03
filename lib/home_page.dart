import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_media/create_post.dart';
import 'package:social_media/main.dart';
import 'package:social_media/post_widget.dart';
import 'package:social_media/services/auth_services.dart';
import 'package:social_media/services/storage_services.dart';
import 'package:social_media/signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = locator<AuthService>();
  final _store = locator<StorageServices>();
  List<Map<String, dynamic>> posts = [];
  Map<String, dynamic>? users = {};

  getPosts() async {
    posts = await _store.getPosts();
    setState(() {});
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
            child: IconButton(
              icon: const Icon(Icons.search, size: 28),
              onPressed: () async {
                await _auth.signOut();
                if (!_auth.isloggedIn) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()));
                }
              },
            ),
          )
        ],
      ),
      body: Center(
          child: ListView.separated(
              cacheExtent: 500,
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
                  ),
                );
              })),
    );
  }
}
