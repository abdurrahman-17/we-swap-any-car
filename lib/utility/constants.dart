import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/configurations.dart';
import '../main.dart';
import '../model/car_model/value_section_input.dart';
import '../presentation/user_type_selection/user_types_selection.dart';

const String appName = 'We Swap Any Car';
const String shortAppName = 'WSAC';
final String environment = dotenv.env['ENV_NAME']!;
final String s3BaseUrl = dotenv.env['BUCKET_URL']!;
final String cloudFront = dotenv.env['CLOUD_FRONT']!;
final int minimumFetchIntervalTime =
    int.parse(dotenv.env['DEFAULT_REMOTE_CONFIG_MIN_FETCH_INTERVAL'] ?? '0');
const int successStatusCode = 200;
const int validationErrorStatusCode = 405;
const int errorStatusCode400 = 400;
const int phoneNumberLength = 11;
const int otpTimer = 60;
const String apiError = "ERROR";
const int videoUploadLimit = 20; // [20MB]
const int imageUploadLimit = 10; // [10MB]
const int multiImageCount = 25; //25 image can pick at a time
const String countryCode = '+44';
const String monekPaymentSuccessCode = "00";
const String httpsTag = "https://";
const String supportMail = "support@weswapanycar.com";

String signUpPassword = "Wsac@123";
String emailType = "EMAIL";
String phoneType = "PHONE";
String loginWithEmailOrPhone = "LOGIN_WITH_EMAIL_OR_PHONE";

//pay types
const String payMe = "Pay me";
const String payYou = "Pay you";

//pay as you go limit error message
const String payAsyouGoLimitExceededMsg =
    "Maximum limit of pay as yo go for the month is reached";

//phone number change request error messages
const String changeRequestExistsSameNumber = "CHANGE_REQUEST_EXISTS";
const String changeRequestExistsDiffNumber = "REQUEST_EXISTS";
const String phoneNumberExistsUpdatePhone = "PHONE_NUMBER_EXIST";
const String changeRequestExistsSameNumberFromDiffUser =
    "REQUEST_WITH_NEW_NUMBER_EXIST";

//swap options
const String swap = "Swap";
const String cash = "Cash";
const String swapAndCash = "Swap + Cash";

//default image url
const String singleUserPlaceHolder =
    "https://firebasestorage.googleapis.com/v0/b/inplass-dev-d0af0.appspot.com/o/new_user.png?alt=media&token=b3bd36f8-2aa1-4a7d-880b-79b5d262714d";

const String groupDefaultLogo =
    'https://firebasestorage.googleapis.com/v0/b/inplass-dev-d0af0.appspot.com/o/new_group.png?alt=media&token=0978a1b5-ac43-43f9-8d0f-5a2ce0274647';

List<String> genderRadioList = [
  maleRadio,
  femaleRadio,
  iWouldRatherNotSay,
];

List<String> userTypesRadioList = [
  tradeType,
  privateType,
];

List<String> carFiveSides = [
  Assets.carDashboard,
  Assets.carFrontView,
  Assets.carRearView,
  Assets.carRightSideView,
  Assets.carLeftSideView
];

void guestNavigation() {
  Navigator.pushNamed(
    globalNavigatorKey.currentContext!,
    SelectUserTypesScreen.routeName,
  );
}

List<CarStatus> unListCarStatus = [
  CarStatus.pending,
  CarStatus.disabled,
];

//chat masking chars
const numberInWords = [
  'zero',
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
  'ten',
  'eleven',
  'twelve',
  'thirteen',
  'fourteen',
  'fifteen',
  'sixteen',
  'seventeen',
  'eighteen',
  'nineteen',
  'twenty',
  'thirty',
  'forty',
  'fifty',
  'sixty',
  'seventy',
  'eighty',
  'ninety',
  'thousand',
  'million',
  'billion',
  'trillion',
  'quadrillion',
  'quintillion',
  'sextillion',
  'septillion',
  'octillion',
  'nonillion',
  'decillion',
];

//file pick extensions
const videoFormats = ["mp4", "mov", "mkv"];
const imageFormats = ["jpg", "jpeg", "png", "heic", "webp"];

//service history list
List<String> serviceRecordList = [
  'None',
  'Partial',
  'Full',
];

//yes or no dropdown values
List<ValuesSectionInput> yesNoSelectableList = [
  ValuesSectionInput(
    id: "Yes",
    name: "Yes",
  ),
  ValuesSectionInput(
    id: "No",
    name: "No",
  ),
];

//numbers
List<ValuesSectionInput> numbersSelectableList = [
  ValuesSectionInput(
    id: "1",
    name: "1",
  ),
  ValuesSectionInput(
    id: "2",
    name: "2",
  ),
  ValuesSectionInput(
    id: "3",
    name: "3",
  ),
  ValuesSectionInput(
    id: "4",
    name: "4",
  ),
  ValuesSectionInput(
    id: "5",
    name: "5",
  ),
];
//usertpes drop down
List<dynamic> filterUserTypeList = [
  {'Dealer': FilterUserTypes.dealer.name},
  {'Private': FilterUserTypes.private.name},
  {'Both': FilterUserTypes.none.name}
];
