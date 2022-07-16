import 'dart:typed_data';
import 'dart:ui';

import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

mixin ScreenshotableWidget<T extends StatefulWidget> on State<T> {
  @protected
  GlobalKey get boundarykey;

  @protected
  SavedScreenshotsRepository get screenshotRepository;

  Future<void> shareScreenshot() async {
    RenderRepaintBoundary boundary = boundarykey.currentContext!
        .findRenderObject()! as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    var screenshotFilePath =
        await screenshotRepository.saveScreenshotData(pngBytes);
    Share.shareFiles(<String>[screenshotFilePath!]);
  }
}
