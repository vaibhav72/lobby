import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/cubits/cubit/auth_cubit.dart';
import 'package:lobby/screens/auth_screens/sign_in.dart';
import 'package:lobby/screens/auth_screens/sign_up.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            print(state);
            if (state is AuthError)
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            if (state is AuthNotRegistered)
              pageController.animateToPage(2,
                  duration: Duration(seconds: 1), curve: Curves.bounceOut);
            if (state is AuthCodeSent)
              pageController.animateToPage(1,
                  duration: Duration(seconds: 1), curve: Curves.bounceOut);
            // TODO: implement listener
          },
          builder: (context, state) {
            return PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                SignInScreen(
                  pageController: pageController,
                ),
                SignUpScreen(
                  pageController: pageController,
                ),
                OTPScreen(
                  pageController: pageController,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
