import 'package:flutter/material.dart';

ThemeData dalleTheme(BuildContext context) {
  const dalleBlack = Color(0xff111827);
  const dalleOrange = Color(0xffea580c);
  const dalleGold = Color(0xffca8a04);
  const whiteSmoke = Color(0xfff5f5f5);
  const dalleGrey = Color(0xff3d4452);

  return Theme.of(context).copyWith(
    bottomNavigationBarTheme: Theme.of(context)
        .bottomNavigationBarTheme
        .copyWith(
            backgroundColor: dalleBlack,
            selectedItemColor: dalleOrange,
            unselectedItemColor: Colors.grey),
    colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: dalleOrange, secondary: dalleGold, tertiary: dalleGrey),
    textTheme: Theme.of(context)
        .textTheme
        .apply(bodyColor: whiteSmoke, displayColor: whiteSmoke),
    iconTheme: Theme.of(context).iconTheme.copyWith(color: dalleGold),
    scaffoldBackgroundColor: dalleBlack,
    hintColor: Colors.grey,
  );
}
