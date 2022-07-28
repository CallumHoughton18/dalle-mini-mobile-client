import 'dart:typed_data';
import 'package:dalle_mobile_client/models/dalle_image.dart';
import 'package:dalle_mobile_client/models/dalle_response.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_images_repository.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:dalle_mobile_client/screens/generate_images_screen/widgets/dalle_future_image_grid_builder.dart';
import 'package:dalle_mobile_client/services/interfaces/share_service.dart';
import 'package:dalle_mobile_client/shared/mixins/screenshotable_widget.dart';
import "package:flutter/material.dart";
import '../../services/interfaces/dalle_api.dart';

class GeneratedImagesScreen extends StatefulWidget {
  final DalleApi dalleApi;
  final SavedImagesRepository imagesRepository;
  final SavedScreenshotsRepository screenshotsRepository;
  final ShareService shareService;
  const GeneratedImagesScreen(
      {Key? key,
      required this.dalleApi,
      required this.imagesRepository,
      required this.shareService,
      required this.screenshotsRepository})
      : super(key: key);

  @override
  State<GeneratedImagesScreen> createState() => _GeneratedImagesScreenState();
}

class _GeneratedImagesScreenState extends State<GeneratedImagesScreen>
    with
        AutomaticKeepAliveClientMixin<GeneratedImagesScreen>,
        ScreenshotableWidget<GeneratedImagesScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  GlobalKey<State<StatefulWidget>> get boundarykey => _repaintKey;

  @override
  SavedScreenshotsRepository get screenshotRepository =>
      widget.screenshotsRepository;

  @override
  ShareService get shareService => widget.shareService;

  final _formKey = GlobalKey<FormState>();
  final _repaintKey = GlobalKey();

  Future<List<DalleImage>?> dallePhotos = Future.value(null);
  final TextEditingController promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const spacing = 10.0;
    var scaffold = Padding(
        padding: const EdgeInsets.all(spacing),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: RepaintBoundary(
              key: _repaintKey,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: promptController,
                          decoration: const InputDecoration(
                              hintText: "Enter your prompt"),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "Prompt cannot be empty";
                            }
                            return null;
                          },
                        ),
                      )),
                      const SizedBox(width: spacing),
                      SizedBox(
                        height: 49,
                        child: ElevatedButton(
                            onPressed: (() {
                              var isValid = _formKey.currentState!.validate();
                              if (isValid) {
                                dallePhotos =
                                    getPhotosFromDalle(promptController.text);
                              }
                              setState(() {});
                            }),
                            child: const Icon(Icons.edit)),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),
                  Flexible(
                    child: DalleFutureImageGridBuilder(
                        context: context, future: dallePhotos),
                  ),
                ],
              ),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder(
                    future: dallePhotos,
                    builder:
                        (context, AsyncSnapshot<List<DalleImage>?> snapshot) {
                      Widget children = const SizedBox.shrink();
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        var data = snapshot.data!;
                        children = IconButton(
                          onPressed: () {
                            widget.imagesRepository
                                .saveImages(promptController.text, data);
                          },
                          icon: const Icon(Icons.save),
                          // label: const Text("Save"),
                        );
                      }
                      return children;
                    }),
                FutureBuilder(
                    future: dallePhotos,
                    builder:
                        (context, AsyncSnapshot<List<DalleImage>?> snapshot) {
                      Widget children = const SizedBox.shrink();
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        var data = snapshot.data!;
                        children = IconButton(
                          splashColor: Colors.white,
                          highlightColor: Colors.black,
                          hoverColor: Colors.black,
                          onPressed: () async {
                            setState(() {});
                            await shareScreenshot();
                            setState(() {});
                          },
                          icon: const Icon(Icons.share),
                          // label: const Text("Share"),
                        );
                      }
                      return children;
                    }),
              ])
        ]));

    super.build(context);
    return scaffold;
  }

  Future<List<DalleImage>> getPhotosFromDalle(String rootImageName) async {
    var imageNum = 0;
    final List<Uint8List> imageData = await widget.dalleApi
        .generateImagesFromPrompt(promptController.text)
        .then((value) => value.toBytes().toList());

    return List.generate(imageData.length, (index) {
      var image = DalleImage(
          imageName: "$rootImageName-$imageNum", imageData: imageData[index]);
      imageNum++;
      return image;
    });
  }
}
