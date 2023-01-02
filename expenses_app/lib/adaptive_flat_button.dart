import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;
  const AdaptiveFlatButton(
      {super.key, required this.text, required this.handler});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: handler,
          )
        : TextButton(
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
            onPressed: handler,
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
