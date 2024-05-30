import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:social_media/home_page.dart';
import 'package:social_media/onboarding_page.dart';
import 'package:social_media/services/auth_services.dart';
import 'package:social_media/services/storage_services.dart';
import 'package:social_media/signin_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media/firebase_options.dart';

GetIt locator = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<StorageServices>(StorageServices());
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _auth = locator<AuthService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(1,45,210,90)),
        useMaterial3: true,
      ),
      home: _auth.isloggedIn ? const HomePage() : const OnBoardingPage(),
      // home: const OnBoardingPage(),
    ); 
  }
}
