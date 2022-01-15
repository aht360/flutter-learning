import 'package:flutter/material.dart';

class DisplayText extends StatelessWidget {
  final int counter;

  DisplayText(this.counter);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$counter',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
