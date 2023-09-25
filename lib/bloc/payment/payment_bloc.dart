import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/payment/payment_checkout_response.dart';
import '../../repository/payment_repo.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitialState()) {
    on<PaymentEvent>((event, emit) {
      emit(PaymentInitialState());
    });
    on<GetCheckoutDetailsEvent>((event, emit) async {
      emit(const CheckoutResponseState(
          checkoutDataFetchStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<PaymentRepo>()
          .getPaymentCheckoutResponse(event.checkoutData);
      final state = result.fold(
          (fail) => CheckoutResponseState(
                checkoutDataFetchStatus: ProviderStatus.error,
                errorMessage: fail.message,
              ), (success) {
        return CheckoutResponseState(
          checkoutDataFetchStatus: ProviderStatus.success,
          paymentCheckoutResponse: success,
        );
      });
      emit(state);
    });
  }
}
