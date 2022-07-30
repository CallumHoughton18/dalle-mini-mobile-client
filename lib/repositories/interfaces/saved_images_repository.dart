import 'package:dalle_mobile_client/models/dalle_image.dart';

abstract class SavedImagesRepository {
  Future<List<DalleImage>> getImages(String parentName);
  Future saveImages(String parentName, List<DalleImage> images);
  Future<List<String>> getAllSavedImagesParentNames();
  Future deleteImages(String parentName);
}
