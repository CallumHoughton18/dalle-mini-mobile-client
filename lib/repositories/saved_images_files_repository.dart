import 'dart:io' as io;
import 'dart:io';
import 'package:dalle_mobile_client/models/dalle_image.dart';
import 'package:dalle_mobile_client/shared/exceptions/dalle_app_exception.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_images_repository.dart';
import 'package:path/path.dart';

class SavedImagesFilesRepository implements SavedImagesRepository {
  // Error handling could be better here, but as the image storage isn't too critical
  // for now I've just wrapped all errors/exceptions and returning a Exception with a FriendlyMessage
  // which can at least be displayed to the user to show something went wrong.
  final String rootPhotoDirectoryName = "prediction-photos";

  Future<Directory> get _applicationDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  @override
  Future<List<DalleImage>> getImages(String parentName) async {
    var imagesData = <DalleImage>[];
    var baseDir = await _applicationDirectory;
    var imagesDirectory =
        io.Directory('${baseDir.path}/$rootPhotoDirectoryName/$parentName');
    var images = imagesDirectory.listSync(recursive: false);
    for (var image in images) {
      var file = File(image.path);
      var data = file.readAsBytesSync();
      var name = basename(image.path);
      imagesData.add(DalleImage(imageName: name, imageData: data));
    }
    return imagesData;
  }

  @override
  Future saveImages(String parentName, List<DalleImage> images) async {
    try {
      var baseDir = await _applicationDirectory;
      var imagesDirectory =
          io.Directory('${baseDir.path}/$rootPhotoDirectoryName/$parentName');

      for (var image in images) {
        var file = File('${imagesDirectory.path}/${image.imageName}.jpg');
        await file.create(recursive: true);
        await file.writeAsBytes(image.imageData);
      }
      return true;
    } catch (_) {
      throw DalleAppException(
          cause: "Error saving images",
          friendlyMessage:
              "An Unknown Error Occurred Saving the Generated Images");
    }
  }

  @override
  Future<List<String>> getAllSavedImagesParentNames() async {
    try {
      var parentNames = <String>[];
      var imagesDirectory = await _getSavedImagesDirectories();
      for (var directory in imagesDirectory) {
        parentNames.add(basename(directory.path));
      }

      return parentNames;
    } catch (_) {
      throw DalleAppException(
          cause: "Error occurred getting image directories",
          friendlyMessage: "An Error Occurred Getting The Saved Images");
    }
  }

  @override
  Future deleteImages(String parentName) async {
    try {
      var imagesDirectory = await _getSavedImagesDirectories()
          .then((value) =>
              value.where((element) => basename(element.path) == parentName))
          .then((value) => value.first);
      await imagesDirectory.delete(recursive: true);
    } catch (_) {
      throw DalleAppException(
          cause: "Error deleting images",
          friendlyMessage: "An Error Deleting The Images");
    }

    return true;
  }

  Future<Iterable<io.Directory>> _getSavedImagesDirectories() async {
    var baseDir = await _applicationDirectory;
    var baseImageDirectory =
        await io.Directory('${baseDir.path}/$rootPhotoDirectoryName/')
            .create(recursive: true);
    var imagesDirectory = await baseImageDirectory
        .list()
        .toList()
        .then((value) => value.whereType<Directory>());
    return imagesDirectory;
  }
}
