import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/bloc/auth/auth_bloc.dart';
import 'package:lobby/bloc/category/category_bloc.dart';
import 'package:lobby/cubits/navigation/navigation_cubit.dart';
import 'package:lobby/cubits/signup/signup_cubit.dart';

import 'package:lobby/repository/auth_repository.dart';
import 'package:lobby/repository/category/category_repository.dart';
import 'package:lobby/screens/auth_screens/onboarding_screen.dart';

import 'package:lobby/screens/home_screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => CategoryRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AuthBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider(
              create: (context) =>
                  SignupCubit(authRepository: context.read<AuthRepository>())),
          BlocProvider(create: (context) => NavigationCubit()),
          BlocProvider(
              create: (context) => CategoryBloc(
                  categoryRepository: context.read<CategoryRepository>())
                ..add(LoadCategories()))
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

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
        ? Scaffold(
            body: Container(
              child: Center(
                child: Text("Lhobby"),
              ),
            ),
          )
        : BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state.status == AuthStatus.authenticated) return HomeScreen();
              return OnBoardingScreen();
            },
          );
  }
}
