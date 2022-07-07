import 'package:flutter/material.dart';

class EmptyImageWidget extends StatelessWidget {
  const EmptyImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/empty.jpg"))),
    );
  }
}
