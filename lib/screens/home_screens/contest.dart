import 'package:flutter/material.dart';

class Contest extends StatefulWidget {
  const Contest({Key key}) : super(key: key);

  @override
  _ContestState createState() => _ContestState();
}

class _ContestState extends State<Contest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("contest"),
    );
  }
}
