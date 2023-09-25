import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  ///method returns bool and can be used for checking either
  ///particular permission is granted or not
  static Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;

    if (status == PermissionStatus.denied ||
        status == PermissionStatus.restricted) {
      return false;
    }
    return true;
  }

  ///A common method used for asking permissions
  static Future<void> askForPermission(Permission permission) async {
    if (!await isPermissionGranted(permission)) {
      await permission.request();
    }
  }
}
