import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically

import 'package:dalle_mobile_client/models/dalle_image.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:path_provider/path_provider.dart';

class SavedScreenshotsFilesRepository implements SavedScreenshotsRepository {
  final String rootPhotoDirectoryName = "prompt-screenshots";
  final String screenshotFileName = "screenshot.png";

  Future<Directory> get _applicationDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  @override
  Future<DalleImage?> getScreenshotData() async {
    var screenshotDirectory = await _getScreenshotDirectory();
    var image = screenshotDirectory.listSync(recursive: false).firstWhereOrNull(
        (element) => basename(element.path) == screenshotFileName);
    if (image == null) return null;

    var file = File(image.path);
    var data = file.readAsBytesSync();
    var name = basename(image.path);
    return DalleImage(imageName: name, imageData: data);
  }

  @override
  Future<String?> saveScreenshotData(Uint8List screenshotData) async {
    var screenshotDirectory = await _getScreenshotDirectory();
    var screenshotFile =
        File('${screenshotDirectory.path}/$screenshotFileName');
    await screenshotFile.create(recursive: true);
    await screenshotFile.writeAsBytes(screenshotData, mode: FileMode.writeOnly);
    return screenshotFile.path;
  }

  Future<Directory> _getScreenshotDirectory() async {
    var baseDir = await _applicationDirectory;
    return Directory('${baseDir.path}/$rootPhotoDirectoryName');
  }
}
