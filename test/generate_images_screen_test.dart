// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dalle_mobile_client/mock_data.dart';
import 'package:dalle_mobile_client/models/dalle_response.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_images_repository.dart';
import 'package:dalle_mobile_client/screens/generate_images_screen/generate_images_screen.dart';
import 'package:dalle_mobile_client/screens/generate_images_screen/widgets/empty_image_widget.dart';
import 'package:dalle_mobile_client/services/interfaces/dalle_api.dart';
import 'package:dalle_mobile_client/shared/widgets/dalle_image_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'generate_images_screen_test.mocks.dart';

@GenerateMocks([DalleApi, SavedImagesRepository])
void main() {
  testWidgets('Should display empty image on initial load',
      (WidgetTester tester) async {
    var mockDalleApi = MockDalleApi();
    var mockSavedImagesRepository = MockSavedImagesRepository();
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: GeneratedImagesScreen(
          dalleApi: mockDalleApi, imagesRepository: mockSavedImagesRepository),
    )));
    await tester.pumpAndSettle();
    expect(find.byType(EmptyImageWidget), findsOneWidget);
  });

  group("Successfully fetch images from Dalle API", () {
    var mockDalleApi = MockDalleApi();
    var mockSavedImagesRepository = MockSavedImagesRepository();
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
        return DalleResponse(imagesAsBase64: imagesAsBase64);
      });

      sut = MaterialApp(
          home: Scaffold(
        body: GeneratedImagesScreen(
          dalleApi: mockDalleApi,
          imagesRepository: mockSavedImagesRepository,
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
          imagesRepository: mockSavedImagesRepository,
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
          imagesRepository: mockSavedImagesRepository,
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
  });
}
