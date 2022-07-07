import 'dart:convert' as convert;
import 'package:dalle_mobile_client/models/dalle_response.dart';
import 'package:dalle_mobile_client/services/interfaces/dalle_api.dart';
import 'package:http/http.dart' as http;

class DalleWebApi implements DalleApi {
  final String authority = "bf.dallemini.ai";

  @override
  Future<DalleResponse> generateImagesFromPrompt(String prompt) async {
    var uri = Uri.https(authority, "/generate");
    var response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode(<String, String>{'prompt': prompt}));

    if (response.statusCode == 200) {
      return DalleResponse.fromJson(convert.jsonDecode(response.body));
    } else {
      throw Exception("Dalle Response Error");
    }
  }
}
