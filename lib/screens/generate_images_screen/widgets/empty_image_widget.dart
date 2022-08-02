import 'package:flutter/material.dart';

class EmptyImageWidget extends StatelessWidget {
  const EmptyImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints.expand(),
        child: const Icon(
          Icons.image_search,
          size: 50,
        ));
  }
}
