import 'package:another_flushbar/flushbar.dart';

import '../../../main.dart';
import '../../core/configurations.dart';

void showSnackBar({
  required String message,
  Duration? duration,
  String? title,
}) {
  if (message.isEmpty) {
    return;
  } else if (message == notConnectedToInternet) {
    title = "Check your connection";
    duration = const Duration(seconds: 4);
  }
  Flushbar<dynamic>? flush;
  flush = Flushbar(
    title: title,
    message: message,
    duration: duration ?? const Duration(seconds: 2),
    mainButton: TextButton(
      onPressed: () {
        try {
          flush?.dismiss(true);
        } on Exception catch (_) {}
      },
      child: Text(
        dismissButton,
        style: TextStyle(color: ColorConstant.kPrimaryLightRed),
      ),
    ),
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(20.r),
    blockBackgroundInteraction: true,
    backgroundColor: Colors.black,
  )..show(globalNavigatorKey.currentContext!);
}
