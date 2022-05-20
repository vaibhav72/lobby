import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lobby/bloc/category/category_bloc.dart';
import 'package:lobby/cubits/navigation/navigation_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lobby/screens/home_screens/contest.dart';
import 'package:lobby/screens/home_screens/category_contest_list.dart';
import 'package:lobby/screens/home_screens/contest_screens/view_contest_participants.dart';
import 'package:lobby/screens/home_screens/settings.dart';
import 'package:lobby/screens/home_screens/view_all_posts.dart';
import 'package:lobby/utils/meta_assets.dart';
import 'package:lobby/utils/meta_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List widgetsList = [ViewAllPosts(), CategoryContestList(), Settings()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Padding(padding: MediaQuery.of(context).padding),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage(
                          MetaAssets.dummyProfile,
                        ),
                        height: MediaQuery.of(context).size.height * .05,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            'Tony Stark',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image(image: AssetImage(MetaAssets.searchIcon)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Image(image: AssetImage(MetaAssets.notificationIcon)),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(child: ViewAllPosts()),
        ],
      ),
    ));
  }
}
