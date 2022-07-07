import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class DalleImage {
  final Uint8List imageData;
  final String imageName;

  const DalleImage({required this.imageName, required this.imageData});
}

extension DalleImageConverting on DalleImage {
  Image toImage() {
    var image = Image.memory(imageData);
    return image;
  }
}

extension DalleImagesConverting on List<DalleImage> {
  Iterable<Image> toImages() sync* {
    for (var item in this) {
      yield item.toImage();
    }
  }
}
