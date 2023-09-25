import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/configurations.dart';
import '../../model/payment/payment_response_model.dart';
import 'payment_screen.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({super.key, required this.url});

  final String url;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late WebViewController controller;
  bool isLoading = true;
  final String successUrl = dotenv.env['SUCCESS_URL']!;
  final String fallbackUrl = dotenv.env['FALL_BACK_URL']!;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            log("payment_web_view-->onPageFinished: $url");
            if (mounted) {
              if (isLoading) {
                setState(() {
                  isLoading = false;
                });
              }
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            log("fallbackUrl:$fallbackUrl");
            log("payment_web_view-->onNavigationRequest-->url: ${request.url}");
            //fail
            if (request.url.startsWith(fallbackUrl)) {
              log("Payment fail");
              Navigator.pop(
                context,
                PaymentResponseModel(
                  isSuccess: false,
                  message: paymentApiFailed,
                ),
              );

              final url = Uri.parse(request.url);
              final params = url.queryParameters;
              log(params.toString());
              return NavigationDecision.prevent;
            }

            ///success url check
            else if (request.url.startsWith(successUrl)) {
              log("Payment success");
              Navigator.pop(
                context,
                PaymentResponseModel(
                  isSuccess: true,
                  message: paymentDoneSuccess,
                ),
              );
              final url = Uri.parse(request.url);
              final params = url.queryParameters;
              final paramsAll = url.queryParametersAll;
              log(params.toString());
              log(paramsAll.toString());
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (isLoading) shimmerPaymentLoader(context)
      ],
    );
  }
}
