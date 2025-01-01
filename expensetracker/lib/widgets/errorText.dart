import 'package:flutter/material.dart';

Widget ErrorText(errorText) => (errorText.length != 0)
    ? Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '*${errorText}',
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
      )
    : SizedBox.shrink();
