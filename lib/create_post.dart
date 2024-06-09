import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:social_media/main.dart';
import 'package:social_media/services/post_service.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File? _image;

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  final _postService = locator<PostService>();
  final user = FirebaseAuth.instance.currentUser;

  
    uploadImageGallary() async {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      String fileName = basename(image!.path);

      setState(() {
        if (image != null) {
          _image = File(image.path);
          print(_image);
        } else {
          print('No image selected.');
        }
      });
    }

    uploadImageCamera() async {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      String fileName = basename(image!.path);

      setState(() {
        if (image != null) {
          _image = File(image.path);
          print(_image);
        } else {
          print('No image selected.');
        }
      });
    }

    createPost(){
      _postService.createPost(
          title: titleController.text,
          description: descController.text,
          file: _image!,
          user: user!.uid
      ).then((_) => {
        titleController.clear(),
        descController.clear(),
        
      }).catchError((e)=>print(e));
    }

    uploadImageDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Upload Image')),
            content: SizedBox(
              height: 50,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        uploadImageGallary()
                            .then((value) => Navigator.pop(context));
                      },
                      child: const Text('Gallery'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        uploadImageCamera();
                      },
                      child: const Text('Camera'),
                    )
                  ],
                ),
              ),
            ),
          );
        });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create Post',
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: titleController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 45, 210, 90)),
                          ),
                          label: Text('Title'),
                          labelStyle: TextStyle(
                              color: Color(0xffC4C3C3), fontFamily: 'Poppins'),
                          floatingLabelStyle: TextStyle(color: Color(0xff4DD969)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Color(0xffeeeeee)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: descController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 45, 210, 90)),
                          ),
                          label: Text('Description'),
                          labelStyle: TextStyle(
                              color: Color(0xffC4C3C3), fontFamily: 'Poppins'),
                          floatingLabelStyle: TextStyle(color: Color(0xff4DD969)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Color(0xffeeeeee)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: _image == null
                            ? const Center(
                                child: Text('No Image Selected',style: TextStyle(color: Colors.red),),
                              )
                            : Image.file(_image!),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          uploadImageDialog(context);
                        },
                        child: const Text('Upload Image'),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 45, 210, 90),
                          minimumSize: const Size(380, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            await createPost();
                            Navigator.pop(context);
                          }
                          setState((){
                            _image = null;
                            titleController.clear();
                            descController.clear();
                          });
                        },
                        child: const Text(
                          'Create Post',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      )
                    ],
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
