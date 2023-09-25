import '../../core/configurations.dart';

Future<T?> showCommonTopModalSheet<T>(BuildContext context, Widget child,
    {bool barrierDismissible = true}) {
  return showGeneralDialog<T?>(
    context: context,
    barrierDismissible: barrierDismissible,
    transitionDuration: const Duration(milliseconds: 250),
    barrierLabel: MaterialLocalizations.of(context).dialogLabel,
    barrierColor: Colors.black.withOpacity(0.8),
    pageBuilder: (context, _, __) => child,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)
            .drive(
                Tween<Offset>(begin: const Offset(0, -1.0), end: Offset.zero)),
        child: Column(
          children: [
            Material(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(39.r),
                bottomRight: Radius.circular(39.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [child],
              ),
            )
          ],
        ),
      );
    },
  );
}
