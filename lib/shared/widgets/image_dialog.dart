import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final Image image;
  const ImageDialog({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 256,
        height: 256,
        decoration: BoxDecoration(
            image: DecorationImage(image: image.image, fit: BoxFit.fitWidth)),
      ),
    );
  }
}
