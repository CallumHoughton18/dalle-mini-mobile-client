import 'package:flutter/material.dart';

ThemeData dalleTheme(BuildContext context) {
  const dalleBlack = Color(0xff111827);
  const dalleBlackElevated = Color(0xff292f3d);
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
        primary: dalleOrange,
        secondary: dalleGold,
        tertiary: dalleGrey,
        background: dalleBlack),
    textTheme: Theme.of(context)
        .textTheme
        .apply(bodyColor: whiteSmoke, displayColor: whiteSmoke),
    inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: dalleGrey)),
        ),
    iconTheme: Theme.of(context).iconTheme.copyWith(color: dalleGold),
    cardTheme: Theme.of(context).cardTheme.copyWith(
        color: dalleBlackElevated, shadowColor: dalleGrey, elevation: 5),
    scaffoldBackgroundColor: dalleBlack,
    hintColor: Colors.grey,
  );
}
