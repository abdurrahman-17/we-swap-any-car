import '../car_model/value_section_input.dart';
import 'body_types.dart';
import 'car_colors.dart';
import 'fuel_types.dart';
import 'transmission_type.dart';

class CarTechnicalDetails {
  bool? isFailed;
  List<BodyTypes>? bodyTypes;
  List<CarColors>? carColors;
  List<FuelTypes>? fuelTypes;
  List<TransmissionTypes>? transmissionTypes;
  List<ValuesSectionInput>? years;
  List<ValuesSectionInput>? noOfDoors;

  CarTechnicalDetails({
    this.isFailed = false,
    this.bodyTypes,
    this.carColors,
    this.fuelTypes,
    this.transmissionTypes,
    this.years,
    this.noOfDoors,
  });

  CarTechnicalDetails.fromJson(Map<String, dynamic> json) {
    if (json['bodyTypes'] != null) {
      final bodyTypesjson = json['bodyTypes'] as List;
      for (var v in bodyTypesjson) {
        bodyTypes!.add(BodyTypes.fromJson(v as Map<String, dynamic>));
      }
    }
    if (json['carColors'] != null) {
      final carColorsjson = json['carColors'] as List;
      for (var v in carColorsjson) {
        carColors!.add(CarColors.fromJson(v as Map<String, dynamic>));
      }
    }
    if (json['fuelTypes'] != null) {
      final fuelTypesJson = json['fuelTypes'] as List;
      for (var v in fuelTypesJson) {
        fuelTypes!.add(FuelTypes.fromJson(v as Map<String, dynamic>));
      }
    }
    if (json['transmissionTypes'] != null) {
      final transmissionTypesjson = json['transmissionTypes'] as List;
      for (var v in transmissionTypesjson) {
        transmissionTypes!
            .add(TransmissionTypes.fromJson(v as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'bodyTypes': bodyTypes!.map((v) => v.toJson()).toList(),
        'carColors': carColors!.map((v) => v.toJson()).toList(),
        'fuelTypes': fuelTypes!.map((v) => v.toJson()).toList(),
        'transmissionTypes': transmissionTypes!.map((v) => v.toJson()).toList(),
      };
}
