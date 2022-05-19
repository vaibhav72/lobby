import 'package:flutter/material.dart';
import 'package:lobby/utils/meta_colors.dart';

class MetaStyles {
  static authInputDecoration({
    String title,
  }) =>
      InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 12, left: 0),
          label: Text(
            title,
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
