import 'package:wsac/core/configurations.dart';
import '../support_chat/support_chat_screen.dart';

class AdminSupportButton extends StatelessWidget {
  const AdminSupportButton({super.key, this.isGuest = false, this.padding});
  final bool isGuest;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? getPadding(right: 10),
      child: IconButton(
        onPressed: () {
          if (isGuest) {
            guestNavigation();
          } else {
            Navigator.pushNamed(
              context,
              SupportChatScreen.routeName,
            );
          }
        },
        icon: const CustomImageView(svgPath: Assets.adminSupport),
      ),
    );
  }
}
