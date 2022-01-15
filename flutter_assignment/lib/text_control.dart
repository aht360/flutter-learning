import 'package:flutter/material.dart';

class TextControl extends StatelessWidget {
  final VoidCallback increaseCounter;

  TextControl(this.increaseCounter);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: increaseCounter,
      child: Text('Click me'),
      textColor: Colors.blue,
    );
  }
}
