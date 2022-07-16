// Mocks generated by Mockito 5.2.0 from annotations
// in dalle_mobile_client/test/generate_images_screen_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:dalle_mobile_client/models/dalle_image.dart' as _i6;
import 'package:dalle_mobile_client/models/dalle_response.dart' as _i2;
import 'package:dalle_mobile_client/repositories/interfaces/saved_images_repository.dart'
    as _i5;
import 'package:dalle_mobile_client/services/interfaces/dalle_api.dart' as _i3;
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

class _FakeDalleResponse_0 extends _i1.Fake implements _i2.DalleResponse {}

/// A class which mocks [DalleApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockDalleApi extends _i1.Mock implements _i3.DalleApi {
  MockDalleApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.DalleResponse> generateImagesFromPrompt(String? prompt) =>
      (super.noSuchMethod(
              Invocation.method(#generateImagesFromPrompt, [prompt]),
              returnValue:
                  Future<_i2.DalleResponse>.value(_FakeDalleResponse_0()))
          as _i4.Future<_i2.DalleResponse>);
}

/// A class which mocks [SavedImagesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSavedImagesRepository extends _i1.Mock
    implements _i5.SavedImagesRepository {
  MockSavedImagesRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i6.DalleImage>> getImages(String? parentName) =>
      (super.noSuchMethod(Invocation.method(#getImages, [parentName]),
              returnValue:
                  Future<List<_i6.DalleImage>>.value(<_i6.DalleImage>[]))
          as _i4.Future<List<_i6.DalleImage>>);
  @override
  _i4.Future<bool> saveImages(
          String? parentName, List<_i6.DalleImage>? images) =>
      (super.noSuchMethod(Invocation.method(#saveImages, [parentName, images]),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<List<String>> getAllSavedImagesParentNames() =>
      (super.noSuchMethod(Invocation.method(#getAllSavedImagesParentNames, []),
              returnValue: Future<List<String>>.value(<String>[]))
          as _i4.Future<List<String>>);
  @override
  _i4.Future<bool> deleteImages(String? parentName) =>
      (super.noSuchMethod(Invocation.method(#deleteImages, [parentName]),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
}