import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wsac/presentation/network_lost_screen.dart';
import 'package:wsac/service/aws_secrets_manger.dart';

import 'core/configurations.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeConfig();
  AWSSecretsManger.secretManager;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult connectivityResult) {
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          //connected
          log("connected");
        } else {
          log("disconnected");
          Navigator.pushNamed(
            globalNavigatorKey.currentContext!,
            NetworkLostScreen.routeName,
          );
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: ScreenUtilInit(
        designSize: const Size(375, 808),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: globalNavigatorKey,
            title: appName,
            theme: themData,
            themeMode: ThemeMode.light,
            onGenerateRoute: generateRoute,
            initialRoute: initialRoute,
          );
        },
      ),
    );
  }
}
