import '../../models/dalle_response.dart';

abstract class DalleApi {
  Future<DalleResponse> generateImagesFromPrompt(String prompt);
}
