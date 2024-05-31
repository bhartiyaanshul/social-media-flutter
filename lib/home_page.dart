import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/create_post.dart';
import 'package:social_media/main.dart';
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

  uploadImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  }

  createPost(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Post'),
          content: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Post Title'
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Post Description'
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      uploadImage();
                    },
                    child: const Text('Upload Image'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Create Post'),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  getPosts() async {
    posts = await _store.getPosts();
    setState(() {});
    print(posts);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
                await _auth.signOut();
                if(!_auth.isloggedIn){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage()));
                }
            },
          )
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey[200],
                // trailing: post['postImage'] != null ? Image.network(post['postImage']) : null,
                title: Column(
                  children: [
                    Text(post['title']),

                    Text(post['description']),
                  ],
                ),
                // subtitle: Text(post['description']),
                leading: post['postImage'] != null ? Image.network(post['postImage']) : null,
              ),
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePost()));
          // getPosts();
        },
        child: const Icon(Icons.add),
      )
    );
  }
}