import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class ZoomDrawerItem extends StatelessWidget {
  const ZoomDrawerItem({
    Key? key,
    required this.mainScreen,
    required this.menuScreen,
    required this.zoomDrawerController,
  }) : super(key: key);
  final Widget mainScreen;
  final Widget menuScreen;
  final ZoomDrawerController? zoomDrawerController;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      mainScreen: mainScreen,

      ///side menu
      menuScreen: menuScreen,
      controller: zoomDrawerController,
      androidCloseOnBackTap: true,
      mainScreenTapClose: true,
      borderRadius: 40,
      angle: 0.0,
      slideWidth: MediaQuery.of(context).size.width * .81,
      openCurve: Curves.fastLinearToSlowEaseIn,
      closeCurve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 20),
      disableDragGesture: true,
    );
  }
}
