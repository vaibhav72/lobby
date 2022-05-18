import 'package:flutter/material.dart';
import 'package:lobby/utils/meta_colors.dart';
import 'package:lobby/utils/meta_styles.dart';

buildButton(
    {@required String title,
    @required Function() handler,
    Color color,
    TextStyle titleStyle}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      splashColor: MetaColors.gradientColorTwo,
      onTap: handler ?? () {},
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: MetaColors.gradient),
        width: double.maxFinite,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title ?? "",
              style: titleStyle ?? TextStyle(color: Colors.white, fontSize: 19),
            ),
          ),
        ),
      ),
    ),
  );
}

class SubTextWidget extends StatelessWidget {
  const SubTextWidget({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(color: MetaColors.subTextColor, fontSize: 12),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    );
  }
}
