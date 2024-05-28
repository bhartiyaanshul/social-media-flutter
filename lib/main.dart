import 'package:flutter/material.dart';
import 'package:social_media/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(1,45,210,90)),
        useMaterial3: true,
      ),
      home: const SignUpPage(),
    ); 
  }
}
