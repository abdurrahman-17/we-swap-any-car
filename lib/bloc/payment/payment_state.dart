part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitialState extends PaymentState {}

class CheckoutResponseState extends PaymentState {
  final ProviderStatus checkoutDataFetchStatus;
  final PaymentCheckoutResponse? paymentCheckoutResponse;
  final String? errorMessage;
  const CheckoutResponseState({
    required this.checkoutDataFetchStatus,
    this.paymentCheckoutResponse,
    this.errorMessage,
  });

  @override
  List<Object> get props => [checkoutDataFetchStatus];
}
