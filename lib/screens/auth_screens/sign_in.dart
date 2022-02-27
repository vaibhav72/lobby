import 'package:flutter/material.dart';
import 'package:lobby/cubits/signup/signup_cubit.dart';
import 'package:lobby/screens/auth_screens/helpers/auth_widgets.dart';
import 'package:lobby/utils/meta_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  final PageController pageController;
  const SignInScreen({Key key, this.pageController}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SIgn In"),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildEmailField(),
                _buildPasswordField(),
                buildButton(
                    title: "Sign In",
                    handler: () {
                      context.read<SignupCubit>().signInWithCredentiails();
                    }),
                GestureDetector(
                  child: Text("New User? Sign up"),
                  onTap: () {
                    widget.pageController.animateToPage(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                )
              ],
            ),
          ),
        ));
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      onChanged: (value) {
        context.read<SignupCubit>().passwordChanged(value);
      },
      obscureText: true,
      decoration: MetaStyles.authInputDecoration(title: "Password"),
    );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      onChanged: (value) {
        context.read<SignupCubit>().emailChanged(value);
      },
      decoration: MetaStyles.authInputDecoration(title: "Email"),
    );
  }
}
