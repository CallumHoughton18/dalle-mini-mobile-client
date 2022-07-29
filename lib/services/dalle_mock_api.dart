import 'package:dalle_mobile_client/mock_data.dart';
import 'package:dalle_mobile_client/models/dalle_response.dart';
import 'package:dalle_mobile_client/services/interfaces/dalle_api.dart';

class DalleMockApi implements DalleApi {
  @override
  Future<DalleResponse> generateImagesFromPrompt(String prompt) async {
    await Future.delayed(Duration(milliseconds: 2000));
    var imagesAsBase64 = <String>[];
    for (var i = 0; i < 9; i++) {
      imagesAsBase64.add(MockData.mockBase64Image.replaceAll("\n", ""));
    }
    return DalleResponse(imagesAsBase64: imagesAsBase64);
  }
}
