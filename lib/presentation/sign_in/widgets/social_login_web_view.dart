import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:wsac/core/configurations.dart';
import '../../common_widgets/common_loader.dart';

class SocialLoginWebView extends StatefulWidget {
  static const String routeName = "SocialLoginWebView";
  const SocialLoginWebView({super.key, required this.url});
  final String url;

  @override
  State<SocialLoginWebView> createState() => _SocialLoginWebViewState();
}

class _SocialLoginWebViewState extends State<SocialLoginWebView> {
  bool isLoading = true;
  String fallbackUrl = dotenv.env['TIKTOK_REDIRECT_URI']!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              onLoadStop: (controller, url) {
                if (mounted) {
                  if (isLoading) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
                if ("$url".startsWith(fallbackUrl)) {
                  final queryParams = url!.queryParameters;
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop(queryParams);
                  }
                }
              },
            ),
            if (isLoading) const Center(child: LottieLoader())
          ],
        ),
      ),
    );
  }
}
