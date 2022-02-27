import 'package:flutter/material.dart';
import 'package:lobby/utils/meta_colors.dart';

MaterialButton buildButton(
    {@required String title,
    @required Function() handler,
    Color color,
    TextStyle titleStyle}) {
  return MaterialButton(
    onPressed: handler ?? () {},
    child: Text(
      title ?? "",
      style: titleStyle ?? TextStyle(color: MetaColors.textColor),
    ),
    color: color ?? MetaColors.primaryColor,
  );
}
