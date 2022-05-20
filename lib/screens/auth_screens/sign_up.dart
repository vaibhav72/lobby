import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/cubits/cubit/auth_cubit.dart';

import 'package:lobby/screens/auth_screens/helpers/auth_widgets.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_styles.dart';
import 'package:lottie/lottie.dart';

class SignUpScreen extends StatefulWidget {
  final PageController pageController;
  const SignUpScreen({Key key, this.pageController}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SIgn In"),
        ),
        body: Container(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 2,
                      child: Lottie.asset(MetaAssets.signUpIllustration)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TitleWidget(
                      title: "Register",
                    ),
                  ),
                  _buildEmailField(),
                  _buildNameField(),
                  const SubTextWidget(
                    title:
                        'Enter your registered mobile number we will send in a OTP for login.',
                  ),
                  Spacer(),
                  buildButton(
                      title: "Submit",
                      handler: () {
                        if (_formKey.currentState.validate()) {
                          context.read<AuthCubit>().createUser(
                              (BlocProvider.of<AuthCubit>(context).state
                                      as AuthNotRegistered)
                                  .userCredentials,
                              emailController.text,
                              nameController.text);
                        }
                      })
                ],
              ),
            ),
          ),
        ));
  }

  _buildNameField() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(top: 0),
            child: TextFormField(
              onChanged: (value) {},
              decoration: MetaStyles.authInputDecoration(title: "Name"),
            ),
          ),
        ),
      ],
    );
  }

  _buildEmailField() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emailController,
              onChanged: (value) {},
              decoration: MetaStyles.authInputDecoration(title: "Email"),
            ),
          ),
        ),
      ],
    );
  }
}
