import 'dart:async';
import 'dart:typed_data';
import 'package:dalle_mobile_client/models/dalle_image.dart';
import 'package:dalle_mobile_client/models/dalle_response.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_images_repository.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:dalle_mobile_client/screens/generate_images_screen/widgets/dalle_future_image_grid_builder.dart';
import 'package:dalle_mobile_client/services/interfaces/share_service.dart';
import 'package:dalle_mobile_client/shared/exceptions/dalle_app_exception.dart';
import 'package:dalle_mobile_client/shared/mixins/screenshotable_widget.dart';
import 'package:dalle_mobile_client/shared/widgets/generate_snackbar.dart';
import "package:flutter/material.dart";
import 'package:screenshot/screenshot.dart';
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
  SavedScreenshotsRepository get screenshotRepository =>
      widget.screenshotsRepository;

  @override
  ShareService get shareService => widget.shareService;

  @override
  ScreenshotController get screenshotController => _screenshotController;

  final _formKey = GlobalKey<FormState>();

  Future<List<DalleImage>?> dallePhotos = Future.value(null);
  final TextEditingController promptController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    const spacing = 10.0;
    var scaffold = Screenshot(
        controller: screenshotController,
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
              padding: const EdgeInsets.all(spacing),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
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
                                      var isValid =
                                          _formKey.currentState!.validate();
                                      if (isValid) {
                                        _getAndSaveDallePhotos(context);
                                      }
                                      setState(() {});
                                    }),
                                    child: const Icon(Icons.edit)),
                              ),
                            ],
                          ),
                          const SizedBox(height: spacing),
                          Flexible(
                            child: DalleFutureImageGridBuilder(
                                context: context, future: dallePhotos),
                          ),
                        ],
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FutureBuilder(
                              future: dallePhotos,
                              builder: (context,
                                  AsyncSnapshot<List<DalleImage>?> snapshot) {
                                Widget children = const SizedBox.shrink();
                                if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  children = IconButton(
                                    onPressed: () async {
                                      await shareScreenshot();
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.share),
                                  );
                                }
                                return children;
                              }),
                        ])
                  ])),
        ));

    super.build(context);
    return scaffold;
  }

  void _getAndSaveDallePhotos(BuildContext context) {
    dallePhotos = _getPhotosFromDalle(promptController.text).then((value) {
      widget.imagesRepository.saveImages(promptController.text, value);
      return value;
    }).catchError((error) {
      var appException = error as DalleAppException;
      generateSnackbar(appException.friendlyMessage, context);
    }, test: (error) => error is DalleAppException);
  }

  Future<List<DalleImage>> _getPhotosFromDalle(String rootImageName) async {
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
