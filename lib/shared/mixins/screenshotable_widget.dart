import 'dart:typed_data';
import 'dart:ui';

import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:dalle_mobile_client/services/interfaces/share_service.dart';
import 'package:dalle_mobile_client/shared/widgets/generate_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin ScreenshotableWidget<T extends StatefulWidget> on State<T> {
  @protected
  GlobalKey get boundarykey;

  @protected
  SavedScreenshotsRepository get screenshotRepository;

  @protected
  ShareService get shareService;

  Future<void> shareScreenshot() {
    // needs to be a slight delay between clicking a button
    // and a screenshot of the page being taken
    // https://github.com/flutter/flutter/issues/22308
    return Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary boundary = boundarykey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;

      try {
        var image = await boundary.toImage();
        ByteData? byteData =
            await image.toByteData(format: ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        var screenshotFilePath =
            await screenshotRepository.saveScreenshotData(pngBytes);

        await shareService.shareFile(screenshotFilePath!);
      } catch (_) {
        generateSnackbar("Error Generating Screenshot...", context);
      }
    });
  }
}
