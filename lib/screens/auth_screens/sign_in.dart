import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lobby/cubits/auth/auth_cubit.dart';import 'package:lobby/screens/auth_screens/helpers/auth_widgets.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lobby/utils/meta_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatefulWidget {
  final PageController pageController;
  const SignInScreen({Key? key, required this.pageController})
      : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  TextEditingController phoneNumberController = TextEditingController();
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
                      child: Lottie.asset(MetaAssets.loginIllustration)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TitleWidget(
                      title: "Log In",
                    ),
                  ),
                  phoneNumberField(),
                  SubTextWidget(
                    title:
                        'Enter your registered mobile number we will send in a OTP for login.',
                  ),
                  Spacer(),
                  buildButton(
                      title: "Log In",
                      handler: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().sendOtp(
                              '+91' + phoneNumberController.text.trim());
                        }
                      })
                ],
              ),
            ),
          ),
        ));
  }

  phoneNumberField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage(
                MetaAssets.loginCallIcon,
              ),
              fit: BoxFit.fill,
              height: 24,
              width: 24,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: phoneNumberController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                cursorColor: MetaColors.textColor,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Phone number cannot be empty";
                  } else if (value.trim().length != 10) {
                    return "Phone number must be of 10 digits";
                  } else
                    return null;
                },
                decoration: MetaStyles.authInputDecoration(
                  title: "Mobile Number",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OTPScreen extends StatefulWidget {
  final PageController pageController;
  const OTPScreen({Key? key, required this.pageController}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In"),
        ),
        body: Container(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 2, child: Lottie.asset(MetaAssets.otpIllustration)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TitleWidget(
                      title: "Enter OTP",
                    ),
                  ),
                  otpField(),
                  SubTextWidget(
                    title:
                        'An 4 digit code has been sent to your mobile number +91 98XXXXXX587',
                  ),
                  Spacer(),
                  buildButton(
                      title: "Submit",
                      handler: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<AuthCubit>()
                              .verifyOTP(otpController.text);
                        }
                      })
                ],
              ),
            ),
          ),
        ));
  }

  otpField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage(
                MetaAssets.otpIcon,
              ),
              fit: BoxFit.fill,
              height: 24,
              width: 24,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: otpController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6)
              ],
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "OTP cannot be empty";
                } else if (value.trim().length != 6) {
                  return "OTP must be of 6 digits";
                } else
                  return null;
              },
              decoration: MetaStyles.authInputDecoration(title: "OTP"),
            ),
          ),
        ],
      ),
    );
  }
}
