import 'package:dartz/dartz.dart';

import '../core/locator.dart';
import '../model/app_update_model.dart';
import '../model/error_model.dart';
import '../service/remote_config_service.dart';

class ApplicationRepo {
  Future<Either<ErrorModel, AppUpdateModel>> getAppUpdate() async {
    return await Locator.instance.get<RemoteConfigService>().getUpdateModel();
  }
}
