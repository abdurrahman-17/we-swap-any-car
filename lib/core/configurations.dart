import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../service/amplify_service/amplify_service.dart';
import '../service/one_signal_service.dart';
import '../service/remote_config_service.dart';
import '../service/shared_preference_service.dart';
import 'locator.dart';
export 'package:flutter/material.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:wsac/presentation/common_widgets/common_drop_down.dart';
export 'package:wsac/presentation/common_widgets/common_textfields.dart';
export 'package:wsac/presentation/common_widgets/custom_buttons.dart';
export 'package:wsac/presentation/common_widgets/custom_image_view.dart';
export 'package:wsac/presentation/common_widgets/custom_scaffold.dart';
export 'package:wsac/presentation/common_widgets/custom_snackbar.dart';
export 'package:wsac/presentation/splash_screen.dart';
export 'package:wsac/theme/app_decoration.dart';
export 'package:wsac/utility/assets.dart';
export 'package:wsac/utility/colors.dart';
export 'package:wsac/utility/common_utils.dart';
export 'package:wsac/utility/constants.dart';
export 'package:wsac/utility/dummy_data.dart';
export 'package:wsac/utility/enums.dart';
export 'package:wsac/utility/scroll_config.dart';
export 'package:wsac/utility/size_utils.dart';
export 'package:wsac/utility/string_utils.dart';
export 'package:wsac/utility/strings.dart';
export 'package:wsac/utility/styles.dart';
export 'package:wsac/utility/theme_data.dart';

///exports

export 'providers.dart';
export 'routes.dart';

Future<void> initializeConfig() async {
  await Firebase.initializeApp();
  await SharedPrefServices.initializeSharedPref();
  await RemoteConfigService().initialize();
  await dotenv.load(fileName: ".dev_env");
  await AmplifyService().configureAmplify();
  await SentryFlutter.init(
    (options) {
      options.environment = dotenv.env['ENV_NAME']!;
      options.dsn = dotenv.env['SENTRY_URL']!;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions
      //for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
  );
  Locator.setup();
  oneSignalInitialize();
  return;
}
