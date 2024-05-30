
import 'package:flutter/material.dart';
import 'package:social_media/home_page.dart';
import 'package:social_media/main.dart';
import 'package:social_media/services/auth_services.dart';
import 'package:social_media/signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formkey = GlobalKey<FormState>();

  final _auth = locator<AuthService>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signIn() async {
    try{
      print(emailController.text);
      print(passwordController.text);
      final user = await _auth.loginUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
      if (user != null) {
        print("User Logged In");
        Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
      else{
        print(user);
      }
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            return null;
                          },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 45, 210, 90)),
                          ),
                          label: Text('Email address'),
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
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
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
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                              signIn();
                            }
                        },
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
              const SizedBox(height: 50),
              // const Expanded(flex: 1, child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have account? Let’s "),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
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
