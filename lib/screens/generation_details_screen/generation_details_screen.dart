import 'package:dalle_mobile_client/models/dalle_image.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:dalle_mobile_client/shared/mixins/screenshotable_widget.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/dalle_image_grid.dart';

class GenerationDetailsScreen extends StatefulWidget {
  final String promptText;
  final List<DalleImage> promptResult;
  final SavedScreenshotsRepository repository;

  const GenerationDetailsScreen(
      {Key? key,
      required this.promptText,
      required this.promptResult,
      required this.repository})
      : super(key: key);

  @override
  State<GenerationDetailsScreen> createState() =>
      _GenerationDetailsScreenState();
}

class _GenerationDetailsScreenState extends State<GenerationDetailsScreen>
    with ScreenshotableWidget {
  final GlobalKey _repaintKey = GlobalKey();

  @override
  GlobalKey<State<StatefulWidget>> get boundarykey => _repaintKey;

  @override
  SavedScreenshotsRepository get screenshotRepository => widget.repository;

  @override
  Widget build(BuildContext context) {
    var images = widget.promptResult.toImages().toList();
    return Scaffold(
        appBar: AppBar(title: const Text("Dalle-Mini Client")),
        body: RepaintBoundary(
          key: _repaintKey,
          child: Column(
            children: [
              Text(widget.promptText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20)),
              DalleImageGrid(context: context, photos: images),
              ElevatedButton(
                  onPressed: () async {
                    await shareScreenshot();
                  },
                  child: const Text("Share Me!"))
            ],
          ),
        ));
  }
}
