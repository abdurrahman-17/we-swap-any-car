import 'dart:developer';
import 'dart:io';

import 'package:wsac/bloc/subscription/subscription_bloc.dart';
import 'package:wsac/core/configurations.dart';
import 'package:wsac/presentation/add_car/screens/check_car_valuation/check_car_worth.dart';
import 'package:wsac/presentation/payment/payment_screen.dart';
// import 'package:wsac/service/graphQl_service/graphql_service.dart';

import '../service/amplify_service/amplify_service.dart';
import '../service/graphQl_service/gq_service.dart';
import '../utility/file_utils.dart';
import 'common_widgets/custom_text_widget.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = "test_screen";
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();
  }

  String? url;
  String? key;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Screen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                AmplifyService().signInUser(
                  emailOrPhone: "ilyas2031@yopmail.com",
                  isSignUp: true,
                );
              },
              child: const Text("SignIn"),
            ),
            ElevatedButton(
              onPressed: () async {
                AmplifyService().confirmSignIn("757215");
              },
              child: const Text("Confirm SignIn"),
            ),
            ElevatedButton(
              onPressed: () async {
                AmplifyService().signInWithSocialLogin(SocialLogin.google);

                // AmplifyService().signOut();
              },
              child: const Text("Social login"),
            ),
            ElevatedButton(
              onPressed: () async {
                AmplifyService().getUserAttributes();
              },
              child: const Text("fetUser attributes"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AmplifyService().signOut();
                // ignore: use_build_context_synchronously
                // Navigator.pushNamedAndRemoveUntil(
                //     context, SignInScreen.routeName, (route) => false);
              },
              child: const Text("SignOut"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AmplifyService().getToken();
              },
              child: const Text("getToken"),
            ),
            ElevatedButton(
              onPressed: () async {
                await AmplifyService().getCognitoUserData();
              },
              child: const Text("get User"),
            ),
            const CenterText(text: "Test Screen"),
            ElevatedButton(
              onPressed: () async {
                File? file =
                    await imagePicker(imageSource: ImageSource.gallery);
                if (file != null) {
                  key = await AmplifyService()
                      .uploadFileToS3Bucket(filePath: file.path);
                }
                if (key != null) {
                  url = await AmplifyService().getS3ImageUrl("1000092545.jpg");
                  setState(() {});
                }
              },
              child: const Text("upload image to s3"),
            ),
            if (url != null)
              SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    url!,
                  )),
            ElevatedButton(
              onPressed: () async {
                GraphQlServices().getCarDetails(
                    key: "_id", value: "643d401a195006e72590ae22");
              },
              child: const Text("GraphQl test"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, CheckCarWorthScreen.routeName);
              },
              child: const Text("CarValuation"),
            ),
            ElevatedButton(
              onPressed: () async {
                BlocProvider.of<SubscriptionBloc>(context)
                    .add(GetSubscriptionDataEvent());
              },
              child: const Text("Bloc test"),
            ),
            ElevatedButton(
              onPressed: () async {
                final result =
                    await Navigator.pushNamed(context, PaymentScreen.routeName);
                log(result.toString());
              },
              child: const Text("Navigation"),
            ),
          ],
        ),
      ),
    );
  }
}
