part of 'need_finance_bloc.dart';

abstract class NeedFinanceState extends Equatable {
  const NeedFinanceState();

  @override
  List<Object> get props => [];
}

class NeedFinanceInitialState extends NeedFinanceState {}

class AddFinanceRequestState extends NeedFinanceState {
  final ProviderStatus needFinanceStatus;
  final AddFinanceRequestResponseModel? needFinanceData;

  const AddFinanceRequestState({
    required this.needFinanceStatus,
    this.needFinanceData,
  });
  @override
  List<Object> get props => [needFinanceStatus];
}
