import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class DalleResponse {
  final List<String> imagesAsBase64;

  const DalleResponse({required this.imagesAsBase64});

  factory DalleResponse.fromJson(Map<String, dynamic> json) {
    var imagesBase64 = <String>[];
    var images = json["images"] as List<String>;
    for (var image in images) {
      imagesBase64.add(image);
    }
    return DalleResponse(imagesAsBase64: imagesBase64);
  }
}

extension DalleResponseConverting on DalleResponse {
  Iterable<Image> toImages() sync* {
    for (var item in imagesAsBase64) {
      var image = Image.memory(base64Decode(item.replaceAll("\n", "")));
      yield image;
    }
  }

  Iterable<Uint8List> toBytes() sync* {
    for (var item in imagesAsBase64) {
      var imageData = base64Decode(item.replaceAll("\n", ""));
      yield imageData;
    }
  }
}
