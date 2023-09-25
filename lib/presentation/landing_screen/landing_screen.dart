import 'package:flutter_zoom_drawer/config.dart';

import '../../core/configurations.dart';
import '../../utility/zoom_drawer_item.dart';
import '../../bloc/application_config/application_config_bloc.dart';
import '../add_car/add_car_stepper_screen.dart';
import '../chat_screen/screens/chat_screen.dart';
import '../common_widgets/side_menu.dart';
import '../liked_cars/liked_cars_screen.dart';
import '../my_cars/my_cars_screen.dart';
import '../swipe_card_layout/swipe_card_layout.dart';
import 'bottom_navigation_bar/bottom_navigation_widget.dart';

class LandingScreen extends StatefulWidget {
  static const String routeName = 'landing_screen';
  const LandingScreen({
    super.key,
    this.selectedIndex = 2,
    this.isGuest = false,
  });
  final int selectedIndex;
  final bool isGuest;
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final zoomDrawerController = ZoomDrawerController();
  int _index = 2;
  bool delete = false;

  @override
  void initState() {
    _index = widget.selectedIndex;
    context.read<ApplicationConfigBloc>().add(GetApplicationUpdateCheckEvent());
    super.initState();
  }

  void drawerOnTap() {
    if (widget.isGuest) {
      guestNavigation();
    } else {
      zoomDrawerController.toggle!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApplicationConfigBloc, ApplicationConfigState>(
      listener: (context, state) {
        if (state is ApplicationUpdateState) {
          final appUpdateDate = state.appUpdateModel;
          launchForceUpdate(appUpdateDate);
        }
      },
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: kPrimaryGradientColor,
          ),
          image: const DecorationImage(
            image: AssetImage(Assets.sideMenuMaskPng),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
        child: ZoomDrawerItem(
          zoomDrawerController: zoomDrawerController,
          mainScreen: switch (_index) {
            0 => MyCarsScreen(
                drawerOnTap: drawerOnTap,
                floatingActionButton: floatingActionButtonWidget(),
                bottomNavigationBar: bottomNavigationBarWidget(),
              ),
            1 => ChatScreenNew(
                drawerOnTap: drawerOnTap,
                floatingActionButton: floatingActionButtonWidget(),
                bottomNavigationBar: bottomNavigationBarWidget(),
              ),
            2 => SwipeCardLayout(
                isGuest: widget.isGuest,
                drawerOnTap: drawerOnTap,
                floatingActionButton: floatingActionButtonWidget(),
                bottomNavigationBar: bottomNavigationBarWidget(),
              ),
            3 => LikedCarsScreen(
                drawerOnTap: drawerOnTap,
                floatingActionButton: floatingActionButtonWidget(),
                bottomNavigationBar: bottomNavigationBarWidget(),
              ),
            _ => const SizedBox(),
          },
          menuScreen: SideMenu(zoomDrawerController: zoomDrawerController),
        ),
      ),
    );
  }

  Widget floatingActionButtonWidget() {
    return Padding(
      padding: getPadding(top: 50.h),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () => setState(() => _index = 2),
        child: Container(
          height: getSize(60),
          width: getSize(60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            gradient: LinearGradient(colors: kPrimaryGradientColor),
          ),
          padding: getPadding(all: 12),
          child: CustomImageView(
            svgPath: Assets.bottomNavCard,
            color: ColorConstant.kColorWhite,
            onLongPress: () {
              if (widget.isGuest) {
                guestNavigation();
              } else {
                Navigator.pushNamed(context, AddCarStepperScreen.routeName);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget bottomNavigationBarWidget() {
    return SafeArea(
      child: FloatingNavbar(
        currentIndex: _index,
        borderRadius: 100,
        selectedBackgroundColor: Colors.transparent,
        selectedItemColor: ColorConstant.kColorWhite,
        margin: getMargin(all: 12),
        onTap: (int val) {
          if (widget.isGuest) {
            guestNavigation();
          } else if (val != 4) {
            setState(() => _index = val);
          } else {}
        },
        items: [
          FloatingNavbarItem(
            customWidget: CustomImageView(
              svgPath: Assets.bottomUser,
              color: _index == 0 ? ColorConstant.kColorWhite : null,
              onTap: () {
                if (widget.isGuest) {
                  guestNavigation();
                } else {
                  setState(() => _index = 0);
                }
              },
            ),
          ),
          FloatingNavbarItem(
            customWidget: CustomImageView(
              svgPath: Assets.bottomChat,
              color: _index == 1 ? ColorConstant.kColorWhite : null,
              onTap: () {
                if (widget.isGuest) {
                  guestNavigation();
                } else {
                  setState(() => _index = 1);
                }
              },
            ),
          ),
          FloatingNavbarItem(customWidget: const SizedBox()),
          FloatingNavbarItem(
            customWidget: CustomImageView(
              svgPath: Assets.bottomLike,
              color: _index == 3 ? ColorConstant.kColorWhite : null,
              onTap: () {
                if (widget.isGuest) {
                  guestNavigation();
                } else {
                  setState(() => _index = 3);
                }
              },
            ),
          ),
          FloatingNavbarItem(
            customWidget: CustomImageView(
              svgPath: Assets.bottomAddCar,
              color: _index == 4 ? ColorConstant.kColorWhite : null,
              onTap: () {
                if (widget.isGuest) {
                  guestNavigation();
                } else {
                  Navigator.pushNamed(context, AddCarStepperScreen.routeName);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
