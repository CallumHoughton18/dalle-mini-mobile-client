import 'package:dalle_mobile_client/models/dalle_image.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/dalle_image_grid.dart';
import 'empty_image_widget.dart';

class DalleFutureImageGridBuilder extends StatelessWidget {
  const DalleFutureImageGridBuilder({
    Key? key,
    required this.context,
    required this.future,
  }) : super(key: key);

  final BuildContext context;
  final Future<List<DalleImage>?> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot<List<DalleImage>?> snapshot) {
          Widget children;
          if (snapshot.connectionState != ConnectionState.done) {
            children = const Center(
              child: SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            children = Center(
              child: SizedBox(
                  width: 600,
                  child: DalleImageGrid(
                      context: context,
                      photos: snapshot.data!.toImages().toList())),
            );
          } else if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return const EmptyImageWidget();
          } else {
            children = const Center(
              child: SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator()),
            );
          }
          return children;
        });
  }
}
