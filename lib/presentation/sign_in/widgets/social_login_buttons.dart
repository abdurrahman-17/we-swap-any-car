import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:wsac/presentation/common_widgets/common_loader.dart';

import '../../../bloc/authentication/authentication_bloc.dart';
import '../../../utility/assets.dart';
import '../../common_widgets/custom_socialmedia_button.dart';

class SocialLoginButtons extends StatefulWidget {
  const SocialLoginButtons({super.key});

  @override
  State<SocialLoginButtons> createState() => _SocialLoginButtonsState();
}

class _SocialLoginButtonsState extends State<SocialLoginButtons> {
  late TwitterLogin twitterLogin;
  late AuthenticationBloc authenticationBloc;
  final String signInRedirectURI = dotenv.env['SIGN_IN_REDIRECT_URI']!;
  final String twitterApiKey = dotenv.env['TWITTER_API_KEY']!;
  final String twitterSecretKey = dotenv.env['TWITTER_SECRET_KEY']!;
  @override
  void initState() {
    super.initState();
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    twitterLogin = TwitterLogin(
      apiKey: twitterApiKey,
      apiSecretKey: twitterSecretKey,
      redirectURI: signInRedirectURI,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(30.w, 22.h, 30.w, 0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomSocialMediaButton(
            asset: Assets.appleAuth,
            onTap: () {
              authenticationBloc.add(SignInWithAppleEvent());
            },
          ),
          // CustomSocialMediaButton(
          //   asset: Assets.facebookAuth,
          //   onTap: () {
          //     authenticationBloc.add(SignInWithFacebookEvent());
          //   },
          // ),
          CustomSocialMediaButton(
            asset: Assets.googleAuth,
            onTap: () {
              authenticationBloc.add(SignInWithGoogleEvent());
            },
          ),
          CustomSocialMediaButton(
            asset: Assets.twitterAuth,
            onTap: () async {
              try {
                setLoader(true);
                final result = await twitterLogin.login();
                setLoader(false);
                if (result.status == TwitterLoginStatus.loggedIn) {
                  authenticationBloc.add(SignInWithTwitterEvent(
                      authToken: result.authToken ?? '',
                      authTokenSecret: result.authTokenSecret ?? ''));
                }
                // ignore: avoid_catches_without_on_clauses
              } catch (e) {
                log("$e");
              }
            },
          ),
          // CustomSocialMediaButton(
          //   asset: Assets.tiktokAuth,
          //   onTap: () async {
          //     final loginResult = await Navigator.pushNamed(
          //         context, SocialLoginWebView.routeName,
          //         arguments: {"url": tiktokLoginURL});
          //     delayedStart(() {
          //       if (loginResult is Map && loginResult['code'] != null) {
          //         log(loginResult.toString());
          //         authenticationBloc.add(SignInWithTikTokEvent(
          //             loginResult: loginResult as Map<String, dynamic>));
          //       }
          //     }, duration: const Duration(seconds: 1));
          //   },
          // ),
          // CustomSocialMediaButton(
          //   asset: Assets.instgramAuth,
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }

  void setLoader(bool isLoader) {
    if (isLoader) {
      progressDialogue();
    } else {
      Navigator.of(context).pop();
    }
  }
}
