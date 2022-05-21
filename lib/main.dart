import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lobby/bloc/category/category_bloc.dart';
import 'package:lobby/cubits/cubit/auth_cubit.dart';
import 'package:lobby/cubits/navigation/navigation_cubit.dart';

import 'package:lobby/repository/category/category_repository.dart';
import 'package:lobby/screens/auth_screens/helpers/auth_widgets.dart';
import 'package:lobby/screens/auth_screens/onboarding_screen.dart';
import 'package:lobby/screens/auth_screens/sign_in.dart';

import 'package:lobby/screens/home_screens/home.dart';
import 'package:lobby/screens/home_screens/settings.dart';
import 'package:lobby/utils/meta_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => CategoryRepository())
      ],
      child: MultiBlocProvider(providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(
            create: (context) => CategoryBloc(
                categoryRepository: context.read<CategoryRepository>())
              ..add(LoadCategories()))
      ], child: SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showLogo = true;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showLogo = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogo
        ? MaterialApp(
            home: Scaffold(
              body: Container(
                child: Center(
                  child: Text("Lhobby"),
                ),
              ),
            ),
          )
        : BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              // print(state);
              log('building main builder');
              if (state is AuthLoggedIn) {
                return MaterialApp(
                    theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      appBarTheme: AppBarTheme(
                          centerTitle: true,
                          color: Colors.white,
                          elevation: 0,
                          titleTextStyle: TextStyle(
                              color: MetaColors.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                      fontFamily: 'Poppins',
                      primarySwatch: Colors.blue,
                    ),
                    home: HomeScreen());
              }
              // if (state is AuthLoading) return Loader(message: state.message);
              else {
                return MaterialApp(
                    theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      appBarTheme: AppBarTheme(
                          centerTitle: true,
                          color: Colors.white,
                          elevation: 0,
                          titleTextStyle: TextStyle(
                              color: MetaColors.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                      fontFamily: 'Poppins',
                      primarySwatch: Colors.blue,
                    ),
                    home: OnBoardingScreen());
              }
            },
          );
  }
}
