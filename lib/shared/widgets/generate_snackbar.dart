import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> generateSnackbar(
    String text, BuildContext context) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(text)));
}
