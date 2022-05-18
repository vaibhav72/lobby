import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      child: Center(
        child: ElevatedButton(
          child: Text("SignOut"),
          onPressed: () {},
        ),
      ),
    ));
  }
}
