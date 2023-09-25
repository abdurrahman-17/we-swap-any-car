import 'package:equatable/equatable.dart';
import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../model/my_matches/my_matches_response_model.dart';
import '../../repository/car_repo.dart';

part 'my_matches_event.dart';
part 'my_matches_state.dart';

class MyMatchesBloc extends Bloc<MyMatchesEvent, MyMatchesState> {
  MyMatchesBloc() : super(MyMatchesInitial()) {
    on<MyMatchesEvent>((event, emit) {});

    on<GetMyMatchesEvent>((event, emit) async {
      emit(GetMyMatchesState(myMatchesStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<CarRepo>()
          .myMatchesRepo(pageNo: event.pageNo, userId: event.userId);

      final GetMyMatchesState state = result.fold((fail) {
        return GetMyMatchesState(myMatchesStatus: ProviderStatus.error);
      }, (myMatches) {
        return GetMyMatchesState(
          myMatchesStatus: ProviderStatus.success,
          myMatchesResponse: myMatches,
        );
      });
      emit(state);
    });

    on<GetMoreMyMatchesEvent>((event, emit) async {
      emit(GetMoreMyMatchesState(myMoreMatchesStatus: ProviderStatus.loading));
      final result = await Locator.instance
          .get<CarRepo>()
          .myMatchesRepo(pageNo: event.pageNo, userId: event.userId);

      final GetMoreMyMatchesState state = result.fold((fail) {
        return GetMoreMyMatchesState(myMoreMatchesStatus: ProviderStatus.error);
      }, (myMatches) {
        return GetMoreMyMatchesState(
          myMoreMatchesStatus: ProviderStatus.success,
          myMoreMatchesResponse: myMatches,
        );
      });
      emit(state);
    });
  }
}
