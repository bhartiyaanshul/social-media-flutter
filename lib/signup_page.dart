import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/services/auth_services.dart';
import 'package:social_media/signin_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formkey = GlobalKey<FormState>();
  File? _image;
  final _auth = AuthService();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    String fileName = basename(image!.path);

    setState(() {
      if (image != null) {
        _image = File(image.path);
        print(_image);
      }
    });
  }

  signUp(){
    _auth
        .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      userName: usernameController.text,
      file: _image!
    ).then((_) {
      emailController.clear();
      passwordController.clear();
      nameController.clear();
      usernameController.clear();
    }).catchError((e)=>print(e));
  }

  uploadImage(){
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Lets create your account',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(1000, 74, 74, 74),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: () => onProfileTapped(),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _image != null
                                  ? Image.file(_image!).image
                                  : null,
                            )),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          controller: nameController,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 45, 210, 90)),
                            ),
                            label: Text('Name'),
                            labelStyle: TextStyle(color: Color(0xffC4C3C3)),
                            floatingLabelStyle:
                                TextStyle(color: Color(0xff4DD969)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Color(0xffeeeeee)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          controller: usernameController,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 45, 210, 90)),
                            ),
                            label: Text('Username'),
                            labelStyle: TextStyle(color: Color(0xffC4C3C3)),
                            floatingLabelStyle:
                                TextStyle(color: Color(0xff4DD969)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Color(0xffeeeeee)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 45, 210, 90)),
                            ),
                            label: Text('Email address'),
                            labelStyle: TextStyle(color: Color(0xffC4C3C3)),
                            floatingLabelStyle:
                                TextStyle(color: Color(0xff4DD969)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Color(0xffeeeeee)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          controller: passwordController,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 45, 210, 90)),
                            ),
                            label: Text('Password'),
                            labelStyle: TextStyle(color: Color(0xffC4C3C3)),
                            floatingLabelStyle:
                                TextStyle(color: Color(0xff4DD969)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Color(0xffeeeeee)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 45, 210, 90),
                            minimumSize: const Size(380, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              signUp();
                            }
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // const Expanded(child: SizedBox()),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have account? "),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInPage()));
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                              color: Color.fromARGB(255, 45, 210, 90)),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

