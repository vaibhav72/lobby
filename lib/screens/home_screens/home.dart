import 'package:flutter/material.dart';
import 'package:lobby/cubits/navigation/navigation_cubit.dart';
import 'package:lobby/cubits/signup/signup_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/screens/home_screens/contest.dart';
import 'package:lobby/screens/home_screens/contest_list.dart';
import 'package:lobby/screens/home_screens/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List widgetsList = [ContestList(), Contest(), Settings()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
              context.read<NavigationCubit>().changeIndex(index: value);
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.sports_cricket), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_history), label: "")
          ]),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return widgetsList[_selectedIndex];
        },
      ),
    );
  }
}
