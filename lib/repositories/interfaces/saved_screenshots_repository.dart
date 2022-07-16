import 'dart:typed_data';

import 'package:dalle_mobile_client/models/dalle_image.dart';

abstract class SavedScreenshotsRepository {
  Future<DalleImage?> getScreenshotData();
  Future<String?> saveScreenshotData(Uint8List screenshotData);
}
