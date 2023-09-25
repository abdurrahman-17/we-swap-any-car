import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/locator.dart';
import '../../model/car_model/car_model.dart';
import '../../repository/car_repo.dart';
import '../../utility/enums.dart';

part 'list_unlist_bloc_event.dart';
part 'list_unlist_bloc_state.dart';

class ListUnlistBlocBloc
    extends Bloc<ListUnlistBlocEvent, ListUnlistBlocState> {
  ListUnlistBlocBloc() : super(ListUnlistBlocInitial()) {
    on<ListUnlistBlocEvent>((event, emit) {});

    //list or unlist car
    on<ListOrUnListMyCarEvent>((event, emit) async {
      emit(const ListOrUnListMyCarState(listStatus: ProviderStatus.loading));

      final result = await Locator.instance.get<CarRepo>().listOrUnListMyCar(
            carId: event.carId,
            userId: event.userId,
            userType: event.userType,
            status: event.status,
          );

      final ListOrUnListMyCarState state = result.fold((fail) {
        return ListOrUnListMyCarState(
            listStatus: ProviderStatus.error, errorMessage: fail.message);
      }, (car) {
        return ListOrUnListMyCarState(
          listStatus: ProviderStatus.success,
          car: car,
        );
      });
      emit(state);
    });

    //delete my car
    on<DeleteMyCarEvent>((event, emit) async {
      emit(DeleteMyCarState(
        deleteStatus: ProviderStatus.loading,
        routeName: event.routeName,
      ));
      final result = await Locator.instance
          .get<CarRepo>()
          .deleteCarRepo(carId: event.carId);
      final DeleteMyCarState state = result.fold((fail) {
        return DeleteMyCarState(
          deleteStatus: ProviderStatus.error,
          errorMessage: fail.message,
          routeName: event.routeName,
        );
      }, (success) {
        return DeleteMyCarState(
          deleteStatus: ProviderStatus.success,
          routeName: event.routeName,
        );
      });
      emit(state);
    });
  }
}
