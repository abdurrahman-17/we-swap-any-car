part of 'need_finance_bloc.dart';

abstract class NeedFinanceEvent extends Equatable {
  const NeedFinanceEvent();

  @override
  List<Object> get props => [];
}

class AddFinanceRequestEvent extends NeedFinanceEvent {
  final Map<String, dynamic> needFinanceData;
  const AddFinanceRequestEvent({required this.needFinanceData});
}
