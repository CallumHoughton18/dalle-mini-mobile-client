import 'package:dalle_mobile_client/screens/shell.dart';
import 'package:dalle_mobile_client/themes/main_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dall-e Mini', theme: dalleTheme(context), home: const Shell());
  }
}
