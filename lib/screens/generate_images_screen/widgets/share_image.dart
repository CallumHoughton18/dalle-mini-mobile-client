import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareImage extends StatefulWidget {
  const ShareImage({Key? key}) : super(key: key);

  @override
  State<ShareImage> createState() => _ShareImageState();
}

class _ShareImageState extends State<ShareImage> {
  static const platform = MethodChannel('dalleclient.flutter.dev/share');
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> _shareGivenImage() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('shareImage');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      var _batteryLevel = batteryLevel;
    });
  }
}
