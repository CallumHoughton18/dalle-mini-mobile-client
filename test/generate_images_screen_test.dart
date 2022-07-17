import 'dart:ffi';

import 'package:dalle_mobile_client/mock_data.dart';
import 'package:dalle_mobile_client/models/dalle_response.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_images_repository.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:dalle_mobile_client/screens/generate_images_screen/generate_images_screen.dart';
import 'package:dalle_mobile_client/screens/generate_images_screen/widgets/empty_image_widget.dart';
import 'package:dalle_mobile_client/services/interfaces/dalle_api.dart';
import 'package:dalle_mobile_client/services/interfaces/share_service.dart';
import 'package:dalle_mobile_client/shared/widgets/dalle_image_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'generate_images_screen_test.mocks.dart';

@GenerateMocks(
    [DalleApi, SavedImagesRepository, SavedScreenshotsRepository, ShareService])
void main() {
  testWidgets('Should display empty image on initial load',
      (WidgetTester tester) async {
    var mockDalleApi = MockDalleApi();
    var mockSavedImagesRepository = MockSavedImagesRepository();
    var mockSavedScreenshotsRepository = MockSavedScreenshotsRepository();
    var mockShareService = MockShareService();
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: GeneratedImagesScreen(
        dalleApi: mockDalleApi,
        shareService: mockShareService,
        imagesRepository: mockSavedImagesRepository,
        screenshotsRepository: mockSavedScreenshotsRepository,
      ),
    )));
    await tester.pumpAndSettle();
    expect(find.byType(EmptyImageWidget), findsOneWidget);
  });

  group("Successfully fetch images from Dalle API", () {
    var mockDalleApi = MockDalleApi();
    var mockSavedImagesRepository = MockSavedImagesRepository();
    var mockSavedScreenshotsRepository = MockSavedScreenshotsRepository();
    var mockShareService = MockShareService();
    var text = "test";
    MaterialApp? sut;

    setUp(() {
      mockDalleApi = MockDalleApi();
      mockSavedImagesRepository = MockSavedImagesRepository();
      when(mockDalleApi.generateImagesFromPrompt(text)).thenAnswer((_) async {
        var imagesAsBase64 = <String>[];
        for (var i = 0; i < 9; i++) {
          imagesAsBase64.add(MockData.mockBase64Image.replaceAll("\n", ""));
        }
        when(mockShareService.shareFile(any)).thenAnswer((_) async {});
        return DalleResponse(imagesAsBase64: imagesAsBase64);
      });
      when(mockSavedScreenshotsRepository.saveScreenshotData(any))
          .thenAnswer((_) async {
        return "screenshot.jpg";
      });

      sut = MaterialApp(
          home: Scaffold(
        body: GeneratedImagesScreen(
          dalleApi: mockDalleApi,
          shareService: mockShareService,
          imagesRepository: mockSavedImagesRepository,
          screenshotsRepository: mockSavedScreenshotsRepository,
        ),
      ));
    });

    testWidgets('Should display loading icon when button clicked',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.[]
      await tester.pumpWidget(sut!);
      await tester.enterText(find.byType(TextField), text);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpWidget(sut!);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should not accept empty prompt', (WidgetTester tester) async {
      final widget = MaterialApp(
          home: Scaffold(
        body: GeneratedImagesScreen(
          dalleApi: mockDalleApi,
          shareService: mockShareService,
          imagesRepository: mockSavedImagesRepository,
          screenshotsRepository: mockSavedScreenshotsRepository,
        ),
      ));
      // Build our app and trigger a frame.[]
      await tester.pumpWidget(widget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(EmptyImageWidget), findsOneWidget);
      verifyNever(mockDalleApi.generateImagesFromPrompt(text));
    });

    testWidgets('Should display image icons', (WidgetTester tester) async {
      final widget = MaterialApp(
          home: Scaffold(
        body: GeneratedImagesScreen(
          dalleApi: mockDalleApi,
          shareService: mockShareService,
          imagesRepository: mockSavedImagesRepository,
          screenshotsRepository: mockSavedScreenshotsRepository,
        ),
      ));
      // Build our app and trigger a frame.[]
      await tester.pumpWidget(widget);
      await tester.enterText(find.byType(TextFormField), text);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpWidget(widget);
      // wait for refresh indicator to stop spinning
      await tester.pumpAndSettle();
      expect(find.byType(DalleImageGrid), findsOneWidget);
    });

    testWidgets('Should be able to share dalle images',
        (WidgetTester tester) async {
      final widget = MaterialApp(
          home: Scaffold(
        body: GeneratedImagesScreen(
          dalleApi: mockDalleApi,
          shareService: mockShareService,
          imagesRepository: mockSavedImagesRepository,
          screenshotsRepository: mockSavedScreenshotsRepository,
        ),
      ));

      await tester.pumpWidget(widget);
      await tester.enterText(find.byType(TextFormField), text);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpWidget(widget);
      // wait for refresh indicator to stop spinning
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        // I don't like this, but otherwise the async callback
        // for the ShareButton isn't 'awaited'
        await tester.tap(find.byKey(const Key('ShareButton')));
        await tester.pumpAndSettle(const Duration(microseconds: 3000));
        await Future.delayed(Duration(milliseconds: 100));
      });

      verify(mockShareService.shareFile(any)).called(1);
    });
  });
}
