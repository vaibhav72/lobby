import 'package:flutter/material.dart';
import 'package:lobby/screens/auth_screens/sign_in.dart';
import 'package:lobby/screens/auth_screens/sign_up.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            SignUpScreen(
              pageController: pageController,
            ),
            SignInScreen(
              pageController: pageController,
            )
          ],
        ),
      ),
    );
  }
}
