import 'package:dalle_mobile_client/shared/widgets/image_dialog.dart';
import 'package:flutter/material.dart';

class DalleImageGrid extends StatelessWidget {
  const DalleImageGrid({
    Key? key,
    required this.context,
    required this.photos,
  }) : super(key: key);

  final BuildContext context;
  final List<Image> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            key: Key("dallegriditem-$index"),
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (_) => ImageDialog(image: photos[index]));
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image(image: photos[index].image)),

            // child: Container(
            //   decoration: BoxDecoration(
            //       image: DecorationImage(
            //           fit: BoxFit.fitWidth, image: photos[index].image)),
            // ),
          );
        });
  }
}
