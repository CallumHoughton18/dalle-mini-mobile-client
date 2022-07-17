// Mocks generated by Mockito 5.2.0 from annotations
// in dalle_mobile_client/test/previous_generations_screen_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;
import 'dart:typed_data' as _i6;

import 'package:dalle_mobile_client/models/dalle_image.dart' as _i4;
import 'package:dalle_mobile_client/repositories/interfaces/saved_images_repository.dart'
    as _i2;
import 'package:dalle_mobile_client/repositories/interfaces/saved_screenshots_repository.dart'
    as _i5;
import 'package:dalle_mobile_client/services/interfaces/share_service.dart'
    as _i7;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [SavedImagesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSavedImagesRepository extends _i1.Mock
    implements _i2.SavedImagesRepository {
  MockSavedImagesRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.DalleImage>> getImages(String? parentName) =>
      (super.noSuchMethod(Invocation.method(#getImages, [parentName]),
              returnValue:
                  Future<List<_i4.DalleImage>>.value(<_i4.DalleImage>[]))
          as _i3.Future<List<_i4.DalleImage>>);
  @override
  _i3.Future<bool> saveImages(
          String? parentName, List<_i4.DalleImage>? images) =>
      (super.noSuchMethod(Invocation.method(#saveImages, [parentName, images]),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<List<String>> getAllSavedImagesParentNames() =>
      (super.noSuchMethod(Invocation.method(#getAllSavedImagesParentNames, []),
              returnValue: Future<List<String>>.value(<String>[]))
          as _i3.Future<List<String>>);
  @override
  _i3.Future<bool> deleteImages(String? parentName) =>
      (super.noSuchMethod(Invocation.method(#deleteImages, [parentName]),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
}

/// A class which mocks [SavedScreenshotsRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSavedScreenshotsRepository extends _i1.Mock
    implements _i5.SavedScreenshotsRepository {
  MockSavedScreenshotsRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.DalleImage?> getScreenshotData() =>
      (super.noSuchMethod(Invocation.method(#getScreenshotData, []),
              returnValue: Future<_i4.DalleImage?>.value())
          as _i3.Future<_i4.DalleImage?>);
  @override
  _i3.Future<String?> saveScreenshotData(_i6.Uint8List? screenshotData) =>
      (super.noSuchMethod(
          Invocation.method(#saveScreenshotData, [screenshotData]),
          returnValue: Future<String?>.value()) as _i3.Future<String?>);
}

/// A class which mocks [ShareService].
///
/// See the documentation for Mockito's code generation for more information.
class MockShareService extends _i1.Mock implements _i7.ShareService {
  MockShareService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> shareFile(String? filePath,
          {String? subject, String? text}) =>
      (super.noSuchMethod(
          Invocation.method(
              #shareFile, [filePath], {#subject: subject, #text: text}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
}
