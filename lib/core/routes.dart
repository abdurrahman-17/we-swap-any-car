import '../model/add_car/common_step_model.dart.dart';
import '../model/car_model/car_model.dart';
import '../model/chat_model/chat_group/chat_group_model.dart';
import '../model/payment/payment_response_model.dart';
import '../model/questionnaire_model/questionnaire_model.dart';
import '../model/user/subscription.dart';
import '../model/user/user_model.dart';
import '../presentation/about_us/about_us.dart';
import '../presentation/add_car/add_car_stepper_screen.dart';
import '../presentation/add_car/car_summary/car_summary.dart';
import '../presentation/add_car/screens/add_information.dart';
import '../presentation/add_car/screens/check_car_valuation/car_valuation_wow.dart';
import '../presentation/add_car/screens/condition_and_damage.dart';
import '../presentation/add_car/screens/confirm_your_car/confirm_your_car_screen.dart';
import '../presentation/add_car/screens/hpi_and_mot.dart';
import '../presentation/add_car/screens/service_history.dart';
import '../presentation/add_car/upload_images_video/upload_photo_and_video_screen.dart';
import '../presentation/add_car/upload_images_video/upload_photos_and_videos_steps.dart';
import '../presentation/add_car/screens/check_car_valuation/check_car_worth.dart';
import '../presentation/chat_screen/screens/blocked_user_screen.dart';
import '../presentation/chat_screen/screens/user_chat_window.dart';
import '../presentation/common_widgets/full_screen_image_viewer.dart';
import '../presentation/common_widgets/full_screen_video_player.dart';
import '../presentation/faq/faq_screen.dart';
import '../presentation/contact_us/contact_us_screen.dart';
import '../presentation/create_avatar/select_profile_avatar.dart';
import '../presentation/sign_in/widgets/social_login_web_view.dart';
import '../presentation/sign_up_profile/sign_up_profile_screen.dart';
import '../presentation/sign_up_profile/widgets/launch_terms_and_conditions.dart';
import '../presentation/delete_questionnaire/delete_questionnaire_initial_screen.dart';
import '../presentation/delete_questionnaire/delete_questonnaire_screen.dart';
import '../presentation/error_screen/error_screen.dart';
import '../presentation/history/transfer_history.dart';
import '../presentation/landing_screen/landing_screen.dart';
import '../presentation/my_cars/my_car_profile_screen.dart';
import '../presentation/my_matches/my_matches.dart';
import '../presentation/need_finance/need_finance_screen.dart';
import '../presentation/network_lost_screen.dart';
import '../presentation/notification/notification_screen.dart';
import '../presentation/payment/payment_screen.dart';
import '../presentation/report_an_issue/report_an_issue_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/sign_in/sign_in_screen.dart';
import '../presentation/slot_purchase/slot_purchase_screen.dart';
import '../presentation/subscription/paid_plan_screen.dart';
import '../presentation/subscription/side_menu/my_subscription_screen.dart';
import '../presentation/subscription/side_menu/payment_history.dart';
import '../presentation/subscription/subscription_screen.dart';
import '../presentation/support_chat/support_chat_screen.dart';
import '../presentation/test_screen.dart';
import '../presentation/user_type_selection/user_types_selection.dart';
import '../presentation/view_match_car/car_profile.dart';
import '../presentation/view_match_car/view_profile.dart';
import 'configurations.dart';

//initial routes
const String initialRoute = SplashScreen.routeName;
// const String initialRoute = TestScreen.routeName;

//all routes must be initialize here..
Route<dynamic> generateRoute(RouteSettings settings) {
  final arguments = settings.arguments;
  Map<String, dynamic> arg =
      arguments != null ? arguments as Map<String, dynamic> : {};
  switch (settings.name) {
    case SplashScreen.routeName:
      bool? isSplash = arg['isSplash'] as bool?;
      return MaterialPageRoute(
          builder: (_) => SplashScreen(isSplash: isSplash ?? true));
    case LandingScreen.routeName:
      int? selectedIndex = arg['selectedIndex'] as int?;
      bool? isGuest = arg['isGuest'] as bool?;
      return MaterialPageRoute(
        builder: (_) => LandingScreen(
          selectedIndex: selectedIndex ?? 2,
          isGuest: isGuest ?? false,
        ),
      );
    case AddCarStepperScreen.routeName:
      final CarModel? carModel = arg['carModel'] as CarModel?;
      return MaterialPageRoute(
        builder: (_) => AddCarStepperScreen(carModel: carModel),
      );
    case CheckCarWorthScreen.routeName:
      final CarModel? carModel = arg['carModel'] as CarModel?;
      return MaterialPageRoute(
          builder: (_) => CheckCarWorthScreen(carModel: carModel));
    case CarValuationWowScreen.routeName:
      final CarModel? carModel = arg['carModel'] as CarModel?;
      final bool? fromEdit = arg['fromEdit'] as bool?;
      return MaterialPageRoute(
        builder: (_) => CarValuationWowScreen(
          carModel: carModel,
          fromEdit: fromEdit,
        ),
      );
    case AddInformationScreen.routeName:
      final CarModel? carModel = arg['carModel'] as CarModel?;
      return MaterialPageRoute(
        builder: (_) => AddInformationScreen(carModel: carModel),
      );
    case HPIAndMOTScreen.routeName:
      final CarModel? carModel = arg['carModel'] as CarModel?;
      return MaterialPageRoute(
          builder: (_) => HPIAndMOTScreen(carModel: carModel));
    case ServiceHistoryScreen.routeName:
      final CarModel? carModel = arg['carModel'] as CarModel?;
      return MaterialPageRoute(
          builder: (_) => ServiceHistoryScreen(carModel: carModel));
    case ConditionAndDamageScreen.routeName:
      final CarModel? carModel = arg['carModel'] as CarModel?;
      return MaterialPageRoute(
          builder: (_) => ConditionAndDamageScreen(carModel: carModel));
    case UploadPhotosAndVideosStepScreen.routeName:
      final CarModel? carModel = arg['carModel'] as CarModel?;
      return MaterialPageRoute(
          builder: (_) => UploadPhotosAndVideosStepScreen(carModel: carModel));
    case UploadPhotosAndVideoScreen.routeName:
      final int? selectedIndex = arg['selectedIndex'] as int?;
      final List<CommonStepsModel>? carDifferentViews =
          arg['carDifferentViews'] as List<CommonStepsModel>?;
      final List<String>? imgUrls = arg['imgUrls'] as List<String>?;
      return MaterialPageRoute(
        builder: (_) => UploadPhotosAndVideoScreen(
          selectedIndex: selectedIndex,
          carDifferentViews: carDifferentViews,
          imgOrVideoUrls: imgUrls,
        ),
      );
    case MyCarProfileScreen.routeName:
      String? carId = arg['carId'] as String?;
      return MaterialPageRoute(
        builder: (_) => MyCarProfileScreen(carId: carId ?? ''),
      );
    case TestScreen.routeName:
      return MaterialPageRoute(builder: (_) => const TestScreen());
    case LaunchTermsAndConditions.routeName:
      String? appBarTitle = arg['appBarTitle'] as String?;
      return MaterialPageRoute(
          builder: (_) => LaunchTermsAndConditions(
                appBarTitle: appBarTitle,
              ));
    case SignInScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SignInScreen());
    case SelectUserTypesScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SelectUserTypesScreen());
    case SignUpProfileScreen.routeName:
      UserType userType = arg['userType'] as UserType;
      bool? isUpgrade = arg['isUpgrade'] as bool?;
      UserModel? userModel = arg['user'] as UserModel?;
      return MaterialPageRoute(
        builder: (_) => SignUpProfileScreen(
          userType: userType,
          isUpgrade: isUpgrade ?? false,
          user: userModel,
        ),
      );
    case SupportChatScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SupportChatScreen());
    case ConfirmYourCarScreen.routeName:
      final CarModel? carModel = arg['carModel'] as CarModel?;
      final bool? fromEdit = arg['fromEdit'] as bool?;
      return MaterialPageRoute(
        builder: (_) => ConfirmYourCarScreen(
          carModel: carModel,
          fromEdit: fromEdit ?? false,
        ),
      );
    case SubscriptionPage.routeName:
      final Map<String, dynamic>? userUpgradeData =
          arg['userUpgradeData'] as Map<String, dynamic>?;
      final bool? payAsYouGoExpired = arg['payAsYouGoExpired'] as bool?;
      final bool? traderInactive = arg['traderInactive'] as bool?;
      return MaterialPageRoute(
          builder: (_) => SubscriptionPage(
                userUpgradeData: userUpgradeData,
                payAsyouGoExpired: payAsYouGoExpired,
                traderInactive: traderInactive,
              ));
    case SelectProfileAvatarScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => const SelectProfileAvatarScreen());
    case CarSummaryScreen.routeName:
      String? carId = arg['carId'] as String?;
      return MaterialPageRoute(
          builder: (_) => CarSummaryScreen(carId: carId ?? ''));
    case FullScreenImageViewer.routeName:
      bool isMultiImage = arg['isMultiImage'] as bool;
      int? initialIndex = arg['initialIndex'] as int?;
      dynamic imageFile = arg['imageFile'];
      List<dynamic> imageList = arg['imageList'] as List<dynamic>? ?? [];
      List<String> svgImages = arg['svgImages'] as List<String>? ?? [];

      return MaterialPageRoute(
        builder: (_) => FullScreenImageViewer(
          isMultiImage: isMultiImage,
          initialIndex: initialIndex,
          imageFile: imageFile,
          imageList: imageList,
          svgImages: svgImages,
        ),
      );
    case FullScreenVideoPlayer.routeName:
      String? networkVideoUrl = arg['networkVideoUrl'] as String?;
      String? fileVideoUrl = arg['fileVideoUrl'] as String?;
      String? assetVideoUrl = arg['assetVideoUrl'] as String?;
      return MaterialPageRoute(
        builder: (_) => FullScreenVideoPlayer(
          networkVideoUrl: networkVideoUrl,
          fileVideoUrl: fileVideoUrl,
          assetVideoUrl: assetVideoUrl,
        ),
      );
    case PaymentScreen.routeName:
      return MaterialPageRoute<PaymentResponseModel?>(
          builder: (_) => PaymentScreen(
                plan: arg["plan"] as SubscriptionModel?,
                user: arg["user"] as UserModel,
                carId: arg["carId"] as String?,
                premiumPostId: arg["premiumPostId"] as String?,
              ));
    case PaidSubscriptionScreen.routeName:
      List<SubscriptionModel> subscriptionPlans =
          arg['subscriptionPlans'] as List<SubscriptionModel>;
      SubscriptionModel plan = arg['plan'] as SubscriptionModel;
      return MaterialPageRoute(
          builder: (_) => PaidSubscriptionScreen(
                subscriptionPlans: subscriptionPlans,
                plan: plan,
              ));
    case CarProfileScreen.routeName:
      final CarModel? carModel = arg['carModel'] as CarModel?;
      return MaterialPageRoute(
          builder: (_) => CarProfileScreen(carModel: carModel));
    case ViewProfileScreen.routeName:
      String? carId = arg['carId'] as String?;
      return MaterialPageRoute(
          builder: (_) => ViewProfileScreen(carId: carId ?? ''));
    case ReportAnIssueScreen.routeName:
      final CarModel? carModel = arg['car'] as CarModel?;
      return MaterialPageRoute(
          builder: (_) => ReportAnIssueScreen(car: carModel));
    case NeedFinanceScreen.routeName:
      return MaterialPageRoute(builder: (_) => const NeedFinanceScreen());
    case FAQScreen.routeName:
      return MaterialPageRoute(builder: (_) => const FAQScreen());
    case NotificationScreen.routeName:
      return MaterialPageRoute(builder: (_) => const NotificationScreen());
    case MyMatches.routeName:
      return MaterialPageRoute(builder: (_) => const MyMatches());
    case ContactUsScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ContactUsScreen());
    case AboutUsScreen.routeName:
      return MaterialPageRoute(builder: (_) => const AboutUsScreen());
    case MySubscriptionPage.routeName:
      final int initialIndex = arg['initialIndex'] as int;
      return MaterialPageRoute(
          builder: (_) => MySubscriptionPage(
                initialIndex: initialIndex,
              ));
    case SettingsPage.routeName:
      return MaterialPageRoute(builder: (_) => const SettingsPage());
    case UserChatScreen.routeName:
      final ChatGroupModel chatGroup = arg['chatGroup'] as ChatGroupModel;
      final String userIdOrAdminUserId =
          arg['userIdOrAdminUserId'] as String? ?? '';
      final int selectedIndex = arg['selectedIndex'] as int? ?? 0;
      return MaterialPageRoute(
        builder: (_) => UserChatScreen(
          chatGroup: chatGroup,
          selectedIndex: selectedIndex,
          userIdOrAdminUserId: userIdOrAdminUserId,
        ),
      );
    case BlockedUsersScreen.routeName:
      return MaterialPageRoute(builder: (_) => const BlockedUsersScreen());
    case TransferHistory.routeName:
      return MaterialPageRoute(builder: (_) => const TransferHistory());
    case DeleteQuestionnaireInitialScreen.routeName:
      final String? carId = arg['carId'] as String?;
      final String? userId = arg['userId'] as String?;
      final SurveyType? surveyType = arg['surveyType'] as SurveyType?;
      return MaterialPageRoute(
        builder: (_) => DeleteQuestionnaireInitialScreen(
          carId: carId,
          userId: userId,
          surveyType: surveyType ?? SurveyType.deletePost,
        ),
      );
    case DeleteQuestionnaireScreen.routeName:
      final SurveyType? surveyType = arg['surveyType'] as SurveyType?;
      final List<QuestionnaireModel> feedbackQuestions =
          arg['feedbackQuestions'] as List<QuestionnaireModel>;
      final String? carId = arg['carId'] as String?;
      final String? userId = arg['userId'] as String?;
      return MaterialPageRoute(
        builder: (_) => DeleteQuestionnaireScreen(
          surveyType: surveyType,
          feedbackQuestions: feedbackQuestions,
          carId: carId,
          userId: userId,
        ),
      );
    case NetworkLostScreen.routeName:
      return MaterialPageRoute(builder: (_) => const NetworkLostScreen());
    case PremiumPaymentHistory.routeName:
      List<Map<String, dynamic>> premiumPostLogs =
          arg['PremiumPostLogs'] as List<Map<String, dynamic>>;
      return MaterialPageRoute(
          builder: (_) => PremiumPaymentHistory(
                premiumPostLogs: premiumPostLogs,
              ));
    case ErrorScreen.routeName:
      final String message = arg['message'] as String;
      final String buttonLabel = arg['buttonLabel'] as String;
      final VoidCallback? onTap = arg['onTap'] as VoidCallback?;
      return MaterialPageRoute(
        builder: (_) => ErrorScreen(
          message: message,
          buttonLabel: buttonLabel,
          onTap: onTap,
        ),
      );
    case SlotPurchase.routeName:
      final SubscriptionPageName subscriptionPageName =
          arg['subscriptionPageName'] as SubscriptionPageName;
      return MaterialPageRoute(
          builder: (_) => SlotPurchase(
                subscriptionPageName: subscriptionPageName,
              ));
    case SocialLoginWebView.routeName:
      final String url = arg['url'] as String;
      return MaterialPageRoute(builder: (_) => SocialLoginWebView(url: url));
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}
