import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/configurations.dart';
import '../../main.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}

class LottieLoader extends StatelessWidget {
  const LottieLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Lottie.asset(
        Assets.colorLoader,
        height: 150.h,
        width: 150.h,
      ),
    );
  }
}

///shimmer loader
Widget shimmerLoader(Widget child) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade200,
    direction: ShimmerDirection.ttb,
    child: child,
  );
}

//progress dialogue with content
Future<void> progressDialogue({bool isCircularProgress = false}) async {
  AlertDialog alert = AlertDialog(
    key: const ObjectKey('loader'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.all(
                MediaQuery.of(globalNavigatorKey.currentContext!).size.width *
                    0.05),
            child: isCircularProgress
                ? const CircularProgressIndicator()
                : Lottie.asset(
                    Assets.colorLoader,
                    height: 150.h,
                    width: 150.h,
                  ),
          ),
        ),
      ],
    ),
  );
  return await showDialog<dynamic>(
    //prevent outside touch
    barrierDismissible: false,
    context: globalNavigatorKey.currentContext!,
    builder: (BuildContext context) {
      //prevent Back button press
      return WillPopScope(onWillPop: () async => false, child: alert);
    },
  );
}
