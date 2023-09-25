import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wsac/core/configurations.dart';

//Base Url
String baseUrl = dotenv.env['BASE_URL']!;
// String baseUrl2 = "https://ryxn595gs7.execute-api.eu-west-2.amazonaws.com";
// String baseUrl3 = "https://uat-api-wsac.emvigotech.co.uk";

//Endpoint

//temp urls ******
// String authSendVerify = '$baseUrl/send-verify';
// String authConfirmVerify = '$baseUrl/confirm-verify';
// String checkUser = '$baseUrl/check-user';

// ********
String authSendVerify = '$baseUrl/auth/send-verify';
String authConfirmVerify = '$baseUrl/auth/confirm-verify';
String checkUser = '$baseUrl/auth/check-user';
String changePhoneNumber = '$baseUrl/auth/update-phone';
String uploadUserImage = '$baseUrl/uploadImage';
String getAvatarVariations = '$baseUrl/createVariations';
String valuationData = '$baseUrl/valuationData';
String hpiData = '$baseUrl/hpiData?vehicle_registration_mark=';
String getAvatars = '$baseUrl/getAvatars';
String getAddress = '$baseUrl/getAddress';
String getAddressDetails = '$baseUrl/getAddressDetails';
String checkout = '$baseUrl/payments/payment/checkout';
String contactUsEmail = '$baseUrl/notification/sendEmail';
String guestCarList = '$baseUrl/guest/car-list';

//Post code API TO DO: PostCode Funcitonality
String postCodeDetailsAPI = 'https://api.postcodes.io/postcodes/';

// Terms & Conditions, Privacy Policy and Cookie Policy
String termsAndConditionsURL = "https://www.weswapanycar.com";
String privacyPolicyURL = "https://www.weswapanycar.com";
String cookiePolicyURL = "https://www.weswapanycar.com";

//cognito update
String updateCognitoURL = '$baseUrl/auth/update-cognito';
//twitter api
String twitterLoginURL = '$baseUrl/auth/oauth/twitter/mobile';
String tiktokLoginURL = "$baseUrl/auth/oauth/tiktok?state=$signUpPassword";
String tiktokTokenURL = "$baseUrl/auth/tiktok/callback/";
