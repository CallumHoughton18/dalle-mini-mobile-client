import 'dart:io' as io;
import 'dart:io';
import 'package:dalle_mobile_client/models/dalle_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_images_repository.dart';
import 'package:path/path.dart';

class SavedImagesFilesRepository implements SavedImagesRepository {
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
  Future<bool> saveImages(String parentName, List<DalleImage> images) async {
    var baseDir = await _applicationDirectory;
    var imagesDirectory =
        io.Directory('${baseDir.path}/$rootPhotoDirectoryName/$parentName');

    for (var image in images) {
      var file = File('${imagesDirectory.path}/${image.imageName}.jpg');
      await file.create(recursive: true);
      await file.writeAsBytes(image.imageData);
    }
    return true;
  }

  @override
  Future<List<String>> getAllSavedImagesParentNames() async {
    var parentNames = <String>[];
    var imagesDirectory = await _getSavedImagesDirectories();
    for (var directory in imagesDirectory) {
      parentNames.add(basename(directory.path));
    }

    return parentNames;
  }

  @override
  Future<bool> deleteImages(String parentName) async {
    try {
      var imagesDirectory = await _getSavedImagesDirectories()
          .then((value) =>
              value.where((element) => basename(element.path) == parentName))
          .then((value) => value.first);
      await imagesDirectory.delete(recursive: true);
    } on StateError catch (_) {
      return false;
    }

    return true;
  }

  Future<Iterable<io.Directory>> _getSavedImagesDirectories() async {
    var baseDir = await _applicationDirectory;
    var imagesDirectory =
        await io.Directory('${baseDir.path}/$rootPhotoDirectoryName/')
            .list()
            .toList()
            .then((value) => value.whereType<Directory>());
    return imagesDirectory;
  }
}
