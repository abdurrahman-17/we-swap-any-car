import 'dart:developer';

import 'amplify_api_manager.dart';

class AmplifyApiService {
  Future<void> getUserData() async {
    var result = await AmplifyApiManager.makeApiCall("user");
    log(result.toString());
  }
}
