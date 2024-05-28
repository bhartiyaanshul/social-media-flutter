import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/signin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  File? _image;

  Future<void> onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
        print(_image);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     // style: ButtonStyle(backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 45, 210, 90)),
        //     icon: const Icon(Icons.arrow_back),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     }),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
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
            GestureDetector(
              onTap: () => onProfileTapped(),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? Image.file(_image!).image : null,
              ) 
              // child: Image.file(_image),
              // child: _image == null ? Container(
              //   height: 100,
              //   width: 100,
              //   decoration: BoxDecoration(
              //     color: const Color.fromARGB(255, 238, 238, 238),
              //     borderRadius: BorderRadius.circular(50),
              //   ),
              //   child: const Icon(
              //     Icons.person,
              //     size: 50,
              //     color: Color.fromARGB(255, 45, 210, 90),
              //   ),
              // ): ClipRRect(
              //     borderRadius: BorderRadius.circular(100),
              //     child: Image.file(
              //         _image!,
              //         fit: BoxFit.cover,
              //         height: 150.0,
              //         width: 150.0,
              //     ),
              // )
            ),
            Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                child: Column(
                  children: [
                    
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 45, 210, 90)),
                        ),
                        label: Text('Name',style: TextStyle(color: Color(0xffC4C3C3))),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Color(0xffeeeeee)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        floatingLabelStyle: TextStyle(color: Color(0xff4DD969)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 45, 210, 90)),
                        ),
                        label: Text('Username',style: TextStyle(color: Color(0xffC4C3C3))),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Color(0xffeeeeee)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 45, 210, 90)),
                        ),
                        label: Text('Email address',style: TextStyle(color: Color(0xffC4C3C3))),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Color(0xffeeeeee)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 45, 210, 90)),
                        ),
                        label: Text('Password',style: TextStyle(color: Color(0xffC4C3C3))),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                              color: Color(0xffeeeeee)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 45, 210, 90),
                        minimumSize: const Size(380, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
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
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have account? "),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage()));
                  },
                  child:
                      const Text("Sign in", style: TextStyle(color: Color.fromARGB(255, 45, 210, 90)),
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}
