import 'dart:ui';

import 'package:flutter/material.dart';

Color appColor = Color(0xFF3077E3);
Color lightAppColor = Color(0xFFF2F7FF);
Color lightColor = Color(0xFFE0E4F5);
Color creditColor = Color(0xFF4CAF50);
Color debitColor = Color(0xFFF44336);

Widget AppButton(String title) {
  return Container(
    padding: EdgeInsets.fromLTRB(35, 8, 35, 8),
    decoration:
        BoxDecoration(color: appColor, borderRadius: BorderRadius.circular(10)),
    child: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget CancelButton(String title) {
  return Container(
    padding: EdgeInsets.fromLTRB(25, 7, 25, 7),
    decoration: BoxDecoration(
        border: Border.all(color: appColor),
        borderRadius: BorderRadius.circular(10)),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
