import 'package:flutter/material.dart';

final themeData = ThemeData(
  primarySwatch: Colors.pink,
  accentColor: Colors.amber,
  canvasColor: const Color.fromRGBO(255, 254, 229, 1),
  fontFamily: 'Raleway',
  textTheme: ThemeData.light().textTheme.copyWith(
        bodyText1: const TextStyle(
          color: Color.fromRGBO(20, 51, 51, 1),
        ),
        bodyText2: const TextStyle(
          color: Color.fromRGBO(20, 51, 51, 1),
        ),
        headline6: const TextStyle(
          fontSize: 20,
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold,
        ),
      ),
);
