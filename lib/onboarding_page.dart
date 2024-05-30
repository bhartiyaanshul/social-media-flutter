import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_media/signup_page.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final List content = [
    'Let’s connect with each other',
    'Let’s connect with each other',
    'Let’s connect with each other',
  ];

  final controller = PageController();

  int get length => 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: PageView.builder(
              controller: controller,
              itemCount: 3,
              itemBuilder: (_, i) {
                return Column(
                  children: [
                    Image.asset(
                      'assets/images/onboarding.png',
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Let’s connect with each other',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w700)),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff919191),
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    ),
                    // const SizedBox(height: 20),
                  ],
                );
              }),
        ),
        SmoothPageIndicator(
          controller: controller,
          count: length,
          effect: const ExpandingDotsEffect(
            dotWidth: 25,
            dotHeight: 10,
            activeDotColor: Color.fromARGB(255, 45, 144, 58),
            dotColor: Color(0xff919191),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 45, 210, 90),
              minimumSize: const Size(380, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()));
            },
            child: const Text(
              'Get Started',
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    ));
  }
}
