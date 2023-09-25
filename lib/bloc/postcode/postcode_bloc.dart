import 'package:equatable/equatable.dart';

import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/post_code/address_detail_model.dart';
import '../../model/post_code/address_model.dart';
import '../../repository/user_repo.dart';

part 'postcode_event.dart';
part 'postcode_state.dart';

class PostCodeDetailsBloc
    extends Bloc<PostCodeDetailsEvent, PostCodeDetailsState> {
  List<AddressModel> addressList = [];
  PostCodeDetailsBloc() : super(PostCodeDetailsInitialState()) {
    on<PostCodeInitialEvent>((event, emit) => emit(
          PostCodeDetailsInitialState(),
        ));
    //get addresses list
    on<GetAddressEvent>((event, emit) async {
      addressList.clear();
      emit(const AddressListState(
        addressFetchStatus: ProviderStatus.loading,
      ));
      final result = await Locator.instance
          .get<UserRepo>()
          .getRelatedAddress(event.postcode);
      addressList = result;
      emit(const AddressListState(
        addressFetchStatus: ProviderStatus.success,
      ));
    });

    //get address detail
    on<GetAddressDetailEvent>((event, emit) async {
      emit(const AddressDetailsState(
        addressDetailStatus: ProviderStatus.loading,
      ));

      final result = await Locator.instance
          .get<UserRepo>()
          .getAddressDetails(event.addressId);
      final state = result.fold(
          (fail) => AddressDetailsState(
                addressDetailStatus: ProviderStatus.error,
                errorMessage: fail.message,
              ), (success) {
        return AddressDetailsState(
          addressDetailStatus: ProviderStatus.success,
          addressDetailModel: success,
        );
      });
      emit(state);
    });
  }
}
