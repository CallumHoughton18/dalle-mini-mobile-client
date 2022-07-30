import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class DalleResponse {
  final List<String> imagesAsBase64;

  const DalleResponse({required this.imagesAsBase64});

  factory DalleResponse.fromJson(Map<String, dynamic> json) {
    var imagesBase64 = <String>[];
    var images = json["images"] as List<dynamic>;
    for (var image in images) {
      var base64 = image as String;
      imagesBase64.add(base64);
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
