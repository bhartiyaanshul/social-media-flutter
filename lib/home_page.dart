import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/create_post.dart';
import 'package:social_media/main.dart';
import 'package:social_media/services/auth_services.dart';
import 'package:social_media/signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = locator<AuthService>();

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
      body: const Center(
        child: Text('Welcome to Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePost()));
        },
        child: const Icon(Icons.add),
      )
    );
  }
}