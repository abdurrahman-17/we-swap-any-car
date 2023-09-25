part of 'valuation_check_bloc.dart';

abstract class ValuationCheckEvent extends Equatable {
  const ValuationCheckEvent();

  @override
  List<Object> get props => [];
}

class GetCarValuationDetails extends ValuationCheckEvent {
  final String registration;
  final String mileage;
  final int exterior;
  const GetCarValuationDetails({
    required this.registration,
    required this.mileage,
    required this.exterior,
  });
}
