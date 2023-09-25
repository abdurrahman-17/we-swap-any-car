import '../../core/configurations.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    Key? key,
    this.title,
    required this.body,
    this.actions,
    this.backgroundColor,
    this.appBarColor,
    this.resizeToAvoidBottomInset = false,
    this.backWidget,
  }) : super(key: key);

  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? appBarColor;
  final bool? resizeToAvoidBottomInset;
  final Widget? backWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? ColorConstant.kBackgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: title != null
          ? AppBar(
              backgroundColor: appBarColor ??
                  backgroundColor ??
                  ColorConstant.kBackgroundColor,
              elevation: 0.0,
              leadingWidth: 60,
              leading: backWidget ??
                  (ModalRoute.of(context)!.canPop
                      ? IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const CustomImageView(
                            svgPath: Assets.backArrow,
                          ),
                        )
                      : null),
              actions: actions,
              centerTitle: true,
              title: Text(title!),
            )
          : null,
      body: body,
    );
  }
}

class CustomDrawerScaffold extends StatelessWidget {
  const CustomDrawerScaffold({
    Key? key,
    this.title,
    required this.body,
    this.actions,
    this.backgroundColor,
    this.appBarColor,
    this.resizeToAvoidBottomInset = false,
    this.backWidget,
    this.drawerOnTap,
    this.floatingActionButton,
    this.bottomNavigationBar,
  }) : super(key: key);

  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? appBarColor;
  final bool? resizeToAvoidBottomInset;
  final Widget? backWidget;
  final VoidCallback? drawerOnTap;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBody: true,
        backgroundColor: backgroundColor ?? ColorConstant.kBackgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: title != null
            ? AppBar(
                backgroundColor: appBarColor ??
                    backgroundColor ??
                    ColorConstant.kBackgroundColor,
                elevation: 0.0,
                leadingWidth: 60,
                leading: IconButton(
                  onPressed: drawerOnTap,
                  icon: const CustomImageView(svgPath: Assets.drawerMenu),
                ),
                actions: actions,
                centerTitle: true,
                title: Text(title!),
              )
            : null,
        body: body,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
