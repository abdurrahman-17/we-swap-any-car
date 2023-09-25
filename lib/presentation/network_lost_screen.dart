import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../core/configurations.dart';

class NetworkLostScreen extends StatefulWidget {
  static const String routeName = 'network_lost_screen';

  const NetworkLostScreen({
    super.key,
  });

  @override
  State<NetworkLostScreen> createState() => _NetworkLostScreenState();
}

class _NetworkLostScreenState extends State<NetworkLostScreen> {
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        //connected
        log("connected");
        Navigator.pop(context);
      } else {
        log("disconnected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            CustomImageView(
              svgPath: Assets.homeBackground,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    svgPath: Assets.networkLost,
                    height: 120.h,
                    width: 120.h,
                  ),
                  SizedBox(
                    height: 22.h,
                  ),
                  Text(
                    "Looks like you've lost connection",
                    style: AppTextStyle.txtPTSansBold12LightgreenA700.copyWith(
                      color: ColorConstant.black900,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    "Please reconnect to use the app",
                    style: AppTextStyle.txtInterRegular12WhiteA700.copyWith(
                      color: ColorConstant.kColor9A9A9A,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return false;
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
