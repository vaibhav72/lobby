import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/cubits/cubit/auth_cubit.dart';
import 'package:lobby/screens/auth_screens/helpers/auth_widgets.dart';
import 'package:lobby/screens/auth_screens/sign_in.dart';
import 'package:lobby/screens/auth_screens/sign_up.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
        if (state is AuthError) {
          log('here');
          ScaffoldMessenger.of(context)
              .showSnackBar(banner(context, state.message, isError: true));
        }
        if (state is AuthNotRegistered) {
          pageController.animateToPage(2,
              duration: Duration(seconds: 1), curve: Curves.bounceOut);
        }
        if (state is AuthCodeSent) {
          print("here");
          // Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(banner(
            context,
            state.message,
          ));
          pageController.animateToPage(1,
              duration: Duration(seconds: 1), curve: Curves.bounceOut);
        }

        if (state is AuthNotLoggedIn || state is AuthInitial)
          pageController.animateToPage(0,
              duration: Duration(seconds: 1), curve: Curves.bounceOut);

        // TODO: implement listener
      }, builder: (context, state) {
        return Stack(
          children: [
            PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                SignInScreen(
                  pageController: pageController,
                ),
                OTPScreen(
                  pageController: pageController,
                ),
                SignUpScreen(
                  pageController: pageController,
                ),
              ],
            ),
            if (state is AuthLoading) Loader(message: state.message),
          ],
        );
      }),
    );
  }
}
