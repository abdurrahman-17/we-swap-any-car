part of 'postcode_bloc.dart';

abstract class PostCodeDetailsEvent extends Equatable {
  const PostCodeDetailsEvent();

  @override
  List<Object> get props => [];
}

class PostCodeInitialEvent extends PostCodeDetailsEvent {}

class GetAddressEvent extends PostCodeDetailsEvent {
  final String postcode;
  const GetAddressEvent({required this.postcode});
}

class GetAddressDetailEvent extends PostCodeDetailsEvent {
  final String addressId;
  const GetAddressDetailEvent({required this.addressId});
}
