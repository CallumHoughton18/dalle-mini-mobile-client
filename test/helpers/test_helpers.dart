import 'dart:convert';

import 'package:dalle_mobile_client/mock_data.dart';
import 'package:dalle_mobile_client/models/dalle_image.dart';

class TestHelpers {
  static List<DalleImage> getMockDalleImageData() {
    var dalleData = <DalleImage>[];
    for (var i = 0; i < 9; i++) {
      dalleData.add(DalleImage(
          imageName: "testImage",
          imageData:
              base64Decode(MockData.mockBase64Image.replaceAll("\n", ""))));
    }
    return dalleData;
  }
}
