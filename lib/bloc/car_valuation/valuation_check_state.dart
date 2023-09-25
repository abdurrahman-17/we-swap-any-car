part of 'valuation_check_bloc.dart';

abstract class ValuationCheckState extends Equatable {
  const ValuationCheckState();

  @override
  List<Object> get props => [];
}

class ValuationCheckInitialState extends ValuationCheckState {}

class ValuationCheckLoadingState extends ValuationCheckState {}

class ValuationCheckErrorState extends ValuationCheckState {
  final String errorMessage;
  const ValuationCheckErrorState({required this.errorMessage});
}

class ValuationCheckSuccessState extends ValuationCheckState {
  final OneAutoResponseModel oneAutoResponse;
  const ValuationCheckSuccessState({required this.oneAutoResponse});
}
