part of 'postcode_bloc.dart';

abstract class PostCodeDetailsState extends Equatable {
  const PostCodeDetailsState();

  @override
  List<Object> get props => [];
}

class PostCodeDetailsInitialState extends PostCodeDetailsState {}

class AddressListState extends PostCodeDetailsState {
  final ProviderStatus addressFetchStatus;
  const AddressListState({
    required this.addressFetchStatus,
  });
  @override
  List<Object> get props => [addressFetchStatus];
}

class AddressDetailsState extends PostCodeDetailsState {
  final ProviderStatus addressDetailStatus;
  final AddressDetailModel? addressDetailModel;
  final String? errorMessage;
  const AddressDetailsState({
    required this.addressDetailStatus,
    this.addressDetailModel,
    this.errorMessage,
  });
  @override
  List<Object> get props => [addressDetailStatus];
}
