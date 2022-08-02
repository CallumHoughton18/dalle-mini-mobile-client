import 'package:dalle_mobile_client/env_var_names.dart';
import 'package:dalle_mobile_client/services/dalle_mock_api.dart';
import 'package:dalle_mobile_client/services/dalle_web_api.dart';
import 'package:dalle_mobile_client/services/interfaces/dalle_api.dart';

DalleApi getDalleApiToUse() {
  const dalleApiToUse =
      String.fromEnvironment(Env.dalleApiToUse, defaultValue: 'WEB');
  if (dalleApiToUse.toUpperCase() == "MOCK") {
    return DalleMockApi();
  } else {
    return DalleWebApi();
  }
}
