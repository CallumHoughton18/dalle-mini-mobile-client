import 'package:dalle_mobile_client/models/dalle_image.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:dalle_mobile_client/repositories/saved_screenshots_files_repository.dart';
import 'package:dalle_mobile_client/screens/previous_generations_screen/widgets/previous_generations_list_view.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../repositories/interfaces/saved_images_repository.dart';
import '../../shared/widgets/dalle_image_grid.dart';
import '../generation_details_screen/generation_details_screen.dart';

class PreviousGenerationsScreen extends StatefulWidget {
  final SavedImagesRepository imagesRepository;
  final SavedScreenshotsRepository screenshotsRepository;
  const PreviousGenerationsScreen(
      {Key? key,
      required this.imagesRepository,
      required this.screenshotsRepository})
      : super(key: key);

  @override
  State<PreviousGenerationsScreen> createState() =>
      _PreviousGenerationsScreenState();
}

class _PreviousGenerationsScreenState extends State<PreviousGenerationsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.imagesRepository.getAllSavedImagesParentNames(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          Widget child = const SizedBox.shrink();
          if (snapshot.hasData) {
            var data = snapshot.data!;
            child = PreviousGenerationsListView(
                data: data,
                itemTapped: onListViewItemTapped,
                onItemRemoved: onListViewItemDeleted);
          }
          return child;
        });
  }

  Future onListViewItemTapped(String dataSelected) async {
    var imageData = await widget.imagesRepository.getImages(dataSelected);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return GenerationDetailsScreen(
          promptResult: imageData,
          promptText: dataSelected,
          repository: widget.screenshotsRepository);
    }));
  }

  void onListViewItemDeleted(String dataDeleted) {
    widget.imagesRepository.deleteImages(dataDeleted);
  }
}
