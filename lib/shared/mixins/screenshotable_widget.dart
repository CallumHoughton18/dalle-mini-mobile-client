import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:dalle_mobile_client/services/interfaces/share_service.dart';
import 'package:dalle_mobile_client/shared/widgets/generate_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

mixin ScreenshotableWidget<T extends StatefulWidget> on State<T> {
  @protected
  ScreenshotController get screenshotController;

  @protected
  SavedScreenshotsRepository get screenshotRepository;

  @protected
  ShareService get shareService;

  Future<void> shareScreenshot() async {
    try {
      var imageData = await screenshotController.capture();
      var screenshotPath =
          await screenshotRepository.saveScreenshotData(imageData!);
      await shareService.shareFile(screenshotPath!);
    } catch (_) {
      generateSnackbar("Error Generating Screenshot...", context);
      rethrow;
    }
  }
}
