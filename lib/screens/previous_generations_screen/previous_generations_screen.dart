import 'package:dalle_mobile_client/models/dalle_image.dart';
import 'package:dalle_mobile_client/screens/previous_generations_screen/widgets/previous_generations_list_view.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../repositories/interfaces/saved_images_repository.dart';
import '../../shared/widgets/dalle_image_grid.dart';

class PreviousGenerationsScreen extends StatefulWidget {
  final SavedImagesRepository imagesRepository;
  const PreviousGenerationsScreen({Key? key, required this.imagesRepository})
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
    var images = imageData.toImages().toList();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: const Text("Dalle-Mini Client")),
          body: Column(
            children: [
              Text(dataSelected,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20)),
              DalleImageGrid(context: context, photos: images),
              ElevatedButton(
                  onPressed: () {
                    Share.share("Yay!");
                    // Share.shareFiles(['${directory.path}/image.jpg'],
                    //     text: dataSelected);
                  },
                  child: const Text("Share Me!"))
            ],
          ));
    }));
  }

  void onListViewItemDeleted(String dataDeleted) {
    widget.imagesRepository.deleteImages(dataDeleted);
  }
}
