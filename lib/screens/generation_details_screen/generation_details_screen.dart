import 'package:dalle_mobile_client/models/dalle_image.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:dalle_mobile_client/services/interfaces/share_service.dart';
import 'package:dalle_mobile_client/shared/mixins/screenshotable_widget.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../../shared/widgets/dalle_image_grid.dart';

class GenerationDetailsScreen extends StatefulWidget {
  final String promptText;
  final List<DalleImage> promptResult;
  final SavedScreenshotsRepository repository;
  final ShareService shareService;

  const GenerationDetailsScreen(
      {Key? key,
      required this.promptText,
      required this.promptResult,
      required this.shareService,
      required this.repository})
      : super(key: key);

  @override
  State<GenerationDetailsScreen> createState() =>
      _GenerationDetailsScreenState();
}

class _GenerationDetailsScreenState extends State<GenerationDetailsScreen>
    with ScreenshotableWidget {
  final _screenshotController = ScreenshotController();

  @override
  SavedScreenshotsRepository get screenshotRepository => widget.repository;

  @override
  ShareService get shareService => widget.shareService;

  @override
  ScreenshotController get screenshotController => _screenshotController;

  @override
  Widget build(BuildContext context) {
    var images = widget.promptResult.toImages().toList();
    const spacing = 10.0;
    return Scaffold(
      appBar: AppBar(title: const Text("Dalle-Mini Client")),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(spacing),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: spacing),
                  child: Text(widget.promptText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5),
                ),
                Flexible(
                  child: DalleImageGrid(context: context, photos: images),
                  flex: 1,
                ),
                const SizedBox(height: spacing),
                IconButton(
                  key: const Key("ShareButton"),
                  onPressed: () async {
                    await shareScreenshot();
                  },
                  icon: const Icon(Icons.share),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
