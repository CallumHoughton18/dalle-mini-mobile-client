import 'package:dalle_mobile_client/repositories/saved_images_files_repository.dart';
import 'package:dalle_mobile_client/repositories/saved_screenshots_files_repository.dart';
import 'package:dalle_mobile_client/screens/generate_images_screen/generate_images_screen.dart';
import 'package:dalle_mobile_client/screens/previous_generations_screen/previous_generations_screen.dart';
import 'package:dalle_mobile_client/services/share_plus_share_service.dart';
import 'package:dalle_mobile_client/shared/app_constants.dart';
import 'package:dalle_mobile_client/tiny_service_generator.dart';
import 'package:flutter/material.dart';

import '../shared/widgets/app_bottom_navigation_bar.dart';

class Shell extends StatefulWidget {
  const Shell({Key? key}) : super(key: key);

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  final List<Widget> pages = <Widget>[
    GeneratedImagesScreen(
      key: const PageStorageKey<AppPage>(AppPage.home),
      dalleApi: getDalleApiToUse(),
      shareService: SharePlusShareService(),
      screenshotsRepository: SavedScreenshotsFilesRepository(),
      imagesRepository: SavedImagesFilesRepository(),
    ),
    PreviousGenerationsScreen(
      key: const PageStorageKey<AppPage>(AppPage.pastImages),
      imagesRepository: SavedImagesFilesRepository(),
      shareService: SharePlusShareService(),
      screenshotsRepository: SavedScreenshotsFilesRepository(),
    )
  ];
  AppPage currentPage = AppPage.home;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(title: const Text("Craiyon")),
      body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: pages),
      bottomNavigationBar: AppBottomNavigationBar(
        onNavItemTapped: onNavItemTapped,
      ),
    );
    return scaffold;
  }

  void onNavItemTapped(AppPage page) {
    setState(() {
      currentPage = page;
      _pageController.jumpToPage(currentPage.index);
    });
  }
}
