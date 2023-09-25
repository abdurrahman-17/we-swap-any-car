import 'dart:async';
import 'package:wsac/presentation/error_screen/error_widget.dart';
import '../../core/configurations.dart';

class ErrorScreen extends StatefulWidget {
  static const String routeName = 'error_screen';

  const ErrorScreen({
    super.key,
    required this.message,
    required this.buttonLabel,
    this.onTap,
  });
  final String message;
  final String buttonLabel;
  final VoidCallback? onTap;

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
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
              child: ErrorWithButtonWidget(
                message: widget.message,
                buttonLabel: widget.buttonLabel,
                onTap: widget.onTap,
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
}
