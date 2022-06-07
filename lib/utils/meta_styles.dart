import 'package:flutter/material.dart';
import 'package:lobby/utils/meta_colors.dart';

class MetaStyles {
  static TextStyle timerTitleStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );
  static TextStyle contestFieldsTitleStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static TextStyle contestFieldsSubTitleStyle = TextStyle(
    fontSize: 12,
  );
  static TextStyle contestFieldRulesStyle = TextStyle(
    fontSize: 11,
  );
  static authInputDecoration({
    String? title,
  }) =>
      InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 12, left: 0),
          label: Text(
            title!,
            style: TextStyle(
                color: MetaColors.subTextColor.withOpacity(0.5), fontSize: 16),
          ),
          hintText: title,
          hintStyle: TextStyle(
              color: MetaColors.subTextColor.withOpacity(0.5), fontSize: 16),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle:
              TextStyle(color: MetaColors.subTextColor.withOpacity(0.5)),
          enabledBorder: borderDecoration,
          focusedBorder: borderDecoration,
          disabledBorder: borderDecoration);

  static UnderlineInputBorder borderDecoration = UnderlineInputBorder(
      borderSide: BorderSide(color: MetaColors.subTextColor.withOpacity(0.5)));
}
