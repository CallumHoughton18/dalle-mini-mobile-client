import 'dart:convert' as convert;
import 'dart:io';
import 'package:dalle_mobile_client/models/dalle_response.dart';
import 'package:dalle_mobile_client/services/exceptions/dalle_api_exceptions.dart';
import 'package:dalle_mobile_client/services/interfaces/dalle_api.dart';
import 'package:http/http.dart' as http;

class DalleWebApi implements DalleApi {
  final String authority = "bf.dallemini.ai";

  @override
  Future<DalleResponse> generateImagesFromPrompt(String prompt) async {
    // Not a big fan of this, seems extremely messy but without adopting
    // a functional library it seems error handling is just messy.
    try {
      var uri = Uri.https(authority, "/generate");
      var response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: convert.jsonEncode(<String, String>{'prompt': prompt}));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return DalleResponse.fromJson(convert.jsonDecode(response.body));
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw DalleApiException(
            cause: response.body,
            friendlyMessage:
                "Error ${response.statusCode}: A Dall-e Mini Client Error Occured");
      } else if (response.statusCode >= 500 && response.statusCode < 600) {
        throw DalleApiException(
            cause: response.body,
            friendlyMessage:
                "Error ${response.statusCode}: A Dall-e Mini Server Error Occured");
      } else {
        throw DalleApiException(
            cause: response.body,
            friendlyMessage:
                "Error ${response.statusCode}: Unsuccessful Response from Dall-e API");
      }
    } on SocketException catch (e) {
      throw DalleApiException(
          cause: "A SocketException occurred",
          friendlyMessage: "Error: No Internet Connection",
          innerException: e);
    } on TypeError catch (e) {
      // This exception will occur in the .fromJson method in DalleResponse
      // if parsing the json fails
      // making an assumption here but should
      throw DalleApiException(
          cause: "TypeError has occurred",
          friendlyMessage: "Unable to Parse Dall-e Mini API Response");
    }
  }
}
