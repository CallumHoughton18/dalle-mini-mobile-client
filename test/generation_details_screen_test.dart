import 'package:dalle_mobile_client/mock_data.dart';
import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart';
import 'package:dalle_mobile_client/screens/generation_details_screen/generation_details_screen.dart';
import 'package:dalle_mobile_client/services/interfaces/share_service.dart';
import 'package:dalle_mobile_client/shared/widgets/image_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'generate_images_screen_test.mocks.dart';
import 'helpers/test_helpers.dart';

@GenerateMocks([SavedScreenshotsRepository, ShareService])
void main() {
  group("When clicked", () {
    MockSavedScreenshotsRepository? mockSavedScreenshotsRepo;
    MockShareService? mockShareService;
    Widget? sut;
    setUp(() {
      mockSavedScreenshotsRepo = MockSavedScreenshotsRepository();
      mockShareService = MockShareService();
      when(mockShareService!.shareFile(any)).thenAnswer((_) async {});

      when(mockSavedScreenshotsRepo!.saveScreenshotData(any))
          .thenAnswer((_) async {
        return "screenshot.jpg";
      });

      sut = MaterialApp(
          home: GenerationDetailsScreen(
        promptText: "Unit Test",
        promptResult: TestHelpers.GetMockDalleImageData(),
        repository: mockSavedScreenshotsRepo!,
        shareService: mockShareService!,
      ));
    });

    testWidgets('share button should share generation',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut!);
      await tester.pumpAndSettle();
      // wait for refresh indicator to stop spinning

      final shareButton = find.byType(IconButton);

      await tester.runAsync(() async {
        // I don't like this, but otherwise the async callback
        // for the ShareButton isn't 'awaited'
        await tester.tap(shareButton);
        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 500));

        verify(mockShareService!.shareFile(any)).called(1);
      });
    });

    testWidgets('an image should display as a popup',
        (WidgetTester tester) async {
      await tester.pumpWidget(sut!);
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        // I don't like this, but otherwise the async callback
        // for the ShareButton isn't 'awaited'
        await tester.tap(find.byKey(Key("dallegriditem-0")));
        await tester.pumpAndSettle();
        expect(find.byType(ImageDialog), findsOneWidget);
      });
    });
  });
}
