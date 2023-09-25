import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../core/configurations.dart';
import '../../../utility/urls.dart';
import '../../common_widgets/common_loader.dart';

class LaunchTermsAndConditions extends StatefulWidget {
  static const String routeName = 'launch_url';

  final String? appBarTitle;
  const LaunchTermsAndConditions({
    super.key,
    required this.appBarTitle,
  });

  @override
  State<LaunchTermsAndConditions> createState() =>
      _LaunchTermsAndConditionsState();
}

class _LaunchTermsAndConditionsState extends State<LaunchTermsAndConditions> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: widget.appBarTitle?.toUpperCase() ?? "TITLE",
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(cookiePolicyURL)),
              onLoadStop: (controller, url) {
                if (mounted) {
                  if (isLoading) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
            ),
            if (isLoading)
              ListView.builder(
                itemCount: 6,
                itemBuilder: ((context, index) {
                  return shimmerLoader(
                    Container(
                      height: 55,
                      margin: getMargin(bottom: 15),
                      decoration: BoxDecoration(
                        color: ColorConstant.kColorWhite,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}
