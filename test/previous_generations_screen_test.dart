import 'package:dalle_mobile_client/repositories/interfaces/saved_images_repository.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:dalle_mobile_client/screens/previous_generations_screen/previous_generations_screen.dart';
import 'package:dalle_mobile_client/screens/previous_generations_screen/widgets/previous_generations_list_view.dart';
import 'package:dalle_mobile_client/services/interfaces/share_service.dart';
import 'package:dalle_mobile_client/shared/widgets/dalle_image_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'helpers/test_helpers.dart';
import 'previous_generations_screen_test.mocks.dart';

@GenerateMocks(
    [SavedImagesRepository, SavedScreenshotsRepository, ShareService])
void main() {
  MockSavedImagesRepository? mockSavedImagesRepository;
  MockSavedScreenshotsRepository? mockSavedScreenshotsRepository;
  MockShareService? mockShareService;
  MaterialApp? sut;
  var mockGenerations = <String>["Test1", "Test2", "Test3"];

  setUp(() {
    mockSavedImagesRepository = MockSavedImagesRepository();
    mockSavedScreenshotsRepository = MockSavedScreenshotsRepository();
    mockShareService = MockShareService();
    when(mockSavedImagesRepository!.getAllSavedImagesParentNames())
        .thenAnswer((_) => Future(() => mockGenerations));
    sut = MaterialApp(
        home: Scaffold(
      body: PreviousGenerationsScreen(
        shareService: mockShareService!,
        imagesRepository: mockSavedImagesRepository!,
        screenshotsRepository: mockSavedScreenshotsRepository!,
      ),
    ));
  });
  testWidgets("Should render previous generations listview with items",
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(sut!);
    await tester.pumpAndSettle();
    expect(find.byType(PreviousGenerationsListView), findsOneWidget);

    for (var mockGeneration in mockGenerations) {
      expect(find.text(mockGeneration), findsOneWidget);
    }
  });

  group("Listview interaction tests", () {
    testWidgets("Should delete generation on delete button click",
        (WidgetTester tester) async {
      var itemToDelete = mockGenerations[0];
      when(mockSavedImagesRepository!.deleteImages(itemToDelete))
          .thenAnswer((realInvocation) => Future(() => true));

      await tester.pumpWidget(sut!);
      await tester.pumpAndSettle();

      var deleteButton = find.byKey(Key('$itemToDelete-DeleteButton'));
      await tester.tap(deleteButton);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text(itemToDelete), findsNothing);
      verify(mockSavedImagesRepository!.deleteImages(itemToDelete)).called(1);
    });
    testWidgets("Should navigate to tapped items image grid",
        (WidgetTester tester) async {
      var itemToTap = mockGenerations[0];
      when(mockSavedImagesRepository!.getImages(itemToTap))
          .thenAnswer((_) => Future(() => TestHelpers.getMockDalleImageData()));

      await tester.pumpWidget(sut!);
      await tester.pumpAndSettle();
      var listViewItem = find.byKey(Key('$itemToTap-ListViewItem'));
      await tester.tap(listViewItem);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(DalleImageGrid), findsOneWidget);
    });
  });
}
