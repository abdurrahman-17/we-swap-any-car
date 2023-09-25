part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class GetCheckoutDetailsEvent extends PaymentEvent {
  final Map<String, dynamic> checkoutData;
  const GetCheckoutDetailsEvent({required this.checkoutData});
}
