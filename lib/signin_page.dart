import 'dart:math';

import 'package:flutter/material.dart';
import 'package:social_media/signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            // style: ButtonStyle(backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 45, 210, 90)),
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              const Text(
                'Hello Again!',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign in to your account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(1000, 74, 74, 74),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 45, 210, 90)),
                          ),
                          label: Text('Password'),
                          labelStyle: TextStyle(color: Color(0xffC4C3C3)),
                          floatingLabelStyle:
                              TextStyle(color: Color(0xff4DD969)),
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
                          label: Text('Password'),
                          labelStyle: TextStyle(color: Color(0xffC4C3C3)),
                          floatingLabelStyle:
                              TextStyle(color: Color(0xff4DD969)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color(0xffeeeeee)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                          onTap: () {
        
                          },
                          child: const Text(
                            "Forgot your password?",
                            style: TextStyle(
                                color: Color.fromARGB(255, 45, 210, 90)
                            ),
                          )
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
                          'Sign in',
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
              const Expanded(flex: 1, child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have account? Let’s "),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                    },
                    child:
                        const Text("Sign up", style: TextStyle(color: Color.fromARGB(255, 45, 210, 90)),
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
