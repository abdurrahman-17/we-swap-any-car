import 'package:dartz/dartz.dart';

import '../core/locator.dart';
import '../model/error_model.dart';
import '../model/payment/payment_checkout_response.dart';
import '../model/payment/payment_status_response_model.dart';
import '../service/api_service/api_service.dart';
import '../service/firebase_service.dart';

class PaymentRepo {
  Future<Either<ErrorModel, PaymentCheckoutResponse>>
      getPaymentCheckoutResponse(Map<String, dynamic> checkoutBody) async =>
          await Locator.instance
              .get<ApiService>()
              .getPaymentCheckoutResponse(checkoutBody);

  //Get Payment status repo
  Stream<PaymentStatusResponseModel> checkPaymentStatus(String transactionId) =>
      Locator.instance.get<FirebaseService>().checkPaymentStatus(transactionId);
}
