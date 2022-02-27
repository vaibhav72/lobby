import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/cubits/signup/signup_cubit.dart';
import 'package:lobby/screens/auth_screens/helpers/auth_widgets.dart';
import 'package:lobby/utils/meta_styles.dart';

class SignUpScreen extends StatefulWidget {
  final PageController pageController;
  const SignUpScreen({Key key, this.pageController}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SIgn In"),
        ),
        body: BlocBuilder<SignupCubit, SignupState>(
          builder: (context, state) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildEmailField(),
                    _buildPasswordField(),
                    _buildConfirmPasswordField(),
                    buildButton(
                        title: "Sign Up",
                        handler: () {
                          context.read<SignupCubit>().signUpWithCredentiails();
                        }),
                    GestureDetector(
                      child: Text("Already a User? Sign In"),
                      onTap: () {
                        widget.pageController.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      onChanged: (value) {
        context.read<SignupCubit>().passwordChanged(value);
        print(context.read<SignupCubit>().state.emailId);
      },
      obscureText: true,
      decoration: MetaStyles.authInputDecoration(title: "Password"),
    );
  }

  TextFormField _buildConfirmPasswordField() {
    return TextFormField(
      onChanged: (value) {},
      obscureText: true,
      decoration: MetaStyles.authInputDecoration(title: "Confirm Password"),
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
