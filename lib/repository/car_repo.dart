import 'package:dartz/dartz.dart';
import 'package:wsac/core/configurations.dart';

import '../core/locator.dart';
import '../model/car_detail_model/hpi_response_model.dart';
import '../model/car_model/car_added_accessories.dart';
import '../model/car_model/car_exterior_grade.dart';
import '../model/car_model/car_hpi_and_mot.dart';
import '../model/car_model/car_hpi_history_check.dart';
import '../model/car_model/car_model.dart';
import '../model/car_model/get_liked_cars_response_model.dart';
import '../model/car_model/my_cars_response.dart';
import '../model/car_model/value_section_input.dart';
import '../model/error_model.dart';
import '../model/get_system_configuration_model.dart';
import '../model/my_matches/my_matches_response_model.dart';
import '../model/need_finance/need_finance_response_model.dart';
import '../model/one_auto_response_model.dart';
import '../model/other_cars_by_user/other_cars_by_user_response_model.dart';
import '../model/report_issue/report_issue_response_model.dart';
import '../model/response_model.dart';
import '../model/technical_details/manufacturer.dart';
import '../model/technical_details/technical_details.dart';
import '../service/api_service/api_service.dart';
import '../service/graphQl_service/gq_service.dart';
import '../utility/date_time_utils.dart';

class CarRepo {
  Future<Either<ErrorModel, GetCarsResponseModel>> getGuestCarlistRepo(
          {required Map<String, dynamic> listingParams}) async =>
      await Locator.instance
          .get<ApiService>()
          .getGuestCarListApi(listingParams: listingParams);

  Future<Either<ErrorModel, OneAutoResponseModel>> checkCarValuationRepo({
    required String registration,
    required String mileage,
    required int exterior,
  }) async =>
      await Locator.instance.get<ApiService>().valuationDataApi(
          registration: registration, exterior: exterior, mileage: mileage);

  Future<Either<ErrorModel, HpiResponseModel>> getCarHPIDetailsRepo(
          {required String registrationMark}) async =>
      await Locator.instance
          .get<ApiService>()
          .hpiDataApi(registrationMark: registrationMark);

  Future<Either<ErrorModel, CarModel>> createCar(
          Map<String, dynamic> carData) async =>
      await Locator.instance.get<GraphQlServices>().createCar(carData: carData);

  ///get car details
  Future<Either<ErrorModel, CarModel?>> confirmCarDetails(
      String registrationNumber) async {
    final result = await Locator.instance
        .get<CarRepo>()
        .getCarHPIDetailsRepo(registrationMark: registrationNumber);

    final Either<ErrorModel, CarModel?> data = result.fold((fail) {
      return Left(ErrorModel(message: "No data found"));
    }, (hpiResponse) {
      CarModel? carModel;
      if (hpiResponse.data != null) {
        final HPIResponseParameter? resultModel =
            hpiResponse.data!.responseParameter;
        if (resultModel != null) {
          carModel = CarModel()
            ..manufacturer = resultModel.manufacturer
            ..model = resultModel.dvlaModelDesc
            ..yearOfManufacture = resultModel.manufacturedYear
            ..colour = resultModel.colour
            ..transmissionType = resultModel.transmission
            ..engineSize = resultModel.engineCapacityCc
            ..fuelType = resultModel.fuelType
            ..hpiAndMot = HpiAndMot(
              historyCheck: HPIHistoryCheck(
                cherishedDataQty: resultModel.cherishedDataQty,
                colourChangesQty: resultModel.colourChangesQty,
                conditionDataQty: resultModel.conditionDataQty,
                financeDataQty: resultModel.financeDataQty,
                highRiskDataQty: resultModel.highRiskDataQty,
                isScrapped: resultModel.isScrapped,
                keeperChangesQty: resultModel.keeperChangesQty,
                stolenVehicleDataQty: resultModel.stolenVehicleDataQty,
                v5cDataQty: resultModel.v5cDataQty,
                vehicleIdentityCheckQty: resultModel.vehicleIdentityCheckQty,
              ),
              vin: resultModel.vehicleIdentificationNumber,
              firstRegisted: resultModel.firstRegistrationDate,
              lastMotDate: resultModel.dateLastUpdated,
              previousOwner: resultModel.keeperChangesQty,
              onFinance: resultModel.financeDataQty ?? false ? yesText : noText,
              keeperStartDate: resultModel.lastKeeperChangeDate,
            );
        }
        return Right(carModel);
      } else {
        return Left(ErrorModel(message: "No data found"));
      }
    });
    return data;
  }

  ///Update Car Details
  Future<Either<ErrorModel, CarModel>> updateCarDetails(
          Map<String, dynamic> carData) async =>
      await Locator.instance.get<GraphQlServices>().updateCar(carData: carData);

  ///Get Car Details
  Future<Either<ErrorModel, CarModel>> getCarDetails(
          {required String key, required String value}) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .getCarDetails(key: key, value: value);

  ///Get My Cars
  Future<Either<ErrorModel, GetCarsResponseModel>> getMyCarsWithFilterRepo({
    Map<String, dynamic>? fetchMyCarjson,
  }) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .getMyCarsWithFilter(filter: fetchMyCarjson);

  ///Get View match Cars
  Future<Either<ErrorModel, GetCarsResponseModel>> getCars(
          {required Map<String, dynamic> listingParams}) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .getCars(listingParams: listingParams);

  ///Get other Cars by user
  Future<Either<ErrorModel, OtherCarsByUserResponseModel>> getOtherCarsByUser(
          Map<String, dynamic> variablesJson) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .getOtherCarsByUser(variablesJson);

  ///fetchCarAccessories
  Future<Either<ErrorModel, List<ListedItem>>> fetchCarAccessories() async =>
      await Locator.instance.get<GraphQlServices>().fetchCarAccessories();

  ///getExteriorGradesList
  Future<Either<ErrorModel, List<ExteriorGrade>>>
      getExteriorGradesList() async =>
          await Locator.instance.get<GraphQlServices>().getExteriorGradesList();

  ///getSystemConfiguration
  Future<Either<ErrorModel, GetSystemConfigurationResponseModel>>
      getSystemConfigurations() async => await Locator.instance
          .get<GraphQlServices>()
          .getSystemConfigurations();

  ///car technical details
  Future<Either<ErrorModel, CarTechnicalDetails>>
      getCarTechincalDetails() async {
    final result =
        await Locator.instance.get<GraphQlServices>().getTechnicalDetails();
    return result.fold((l) => Left(l), (response) {
      response
        ..years = getManufactureYear
        ..noOfDoors = getCarNumberOfDoors;
      return Right(response);
    });
  }

  ///get manufacture  year
  List<ValuesSectionInput> get getManufactureYear {
    List<ValuesSectionInput> yearsList = [];
    int maxYear = getCurrentDateTime().year;
    int minYear = 1950;
    for (int i = minYear; i <= maxYear; i++) {
      yearsList.add(ValuesSectionInput(id: "$i", name: "$i"));
    }
    return yearsList;
  }

  ///fetching car door type
  List<ValuesSectionInput> get getCarNumberOfDoors {
    List<ValuesSectionInput> noofDoorsList = [];
    for (int i = 2; i <= 7; i++) {
      noofDoorsList.add(ValuesSectionInput(id: "$i", name: "$i"));
    }
    return noofDoorsList;
  }

  ///Get Car manufacturer dropdown
  Future<Either<ErrorModel, List<ValuesSectionInput>>>
      getManufacturers() async {
    final result =
        await Locator.instance.get<GraphQlServices>().getCarManufacturers();

    return result.fold((error) {
      return Left(error);
    }, (data) {
      List<ValuesSectionInput> list = [];
      list =
          data.map((e) => ValuesSectionInput(id: e.id, name: e.name)).toList();
      return Right(list);
    });
  }

  ///Get Car manufacturer and models
  Future<Either<ErrorModel, List<Manufacturers>>>
      getManufacturersWithmodels() async =>
          await Locator.instance.get<GraphQlServices>().getCarManufacturers();

  ///Issue Types
  Future<Either<ErrorModel, List<ValuesSectionInput>>> getIssueTypes() async {
    var result =
        await Locator.instance.get<GraphQlServices>().getIssueTypesQuery();

    final data = result.map((issueTypes) => issueTypes
        .map((e) => ValuesSectionInput(name: e.name!, id: e.id!))
        .toList());

    return data;
  }

  ///Report issue
  Future<Either<ErrorModel, ReportIssueResponseModel>> reportIssue(
          Map<String, dynamic> reportIssueData) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .reportIssue(reportIssueData);

  ///Need Finance
  Future<Either<ErrorModel, AddFinanceRequestResponseModel>> addFinanceRequest(
          Map<String, dynamic> needFinanceData) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .addFinanceRequest(needFinanceData);

  ///Get Liked Cars with filter
  Future<Either<ErrorModel, GetLikedCarsResponseModel>> getLikedCarsWithSearch(
          {required Map<String, dynamic> likedCarJson}) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .getLikedCarsWithSearch(likedCarJson: likedCarJson);

  //Liked the cars
  Future<Either<ErrorModel, ResponseModel>> likeCarRepo(
          {required Map<String, dynamic> likeInfoJson}) async =>
      await Locator.instance.get<GraphQlServices>().likeACar(likeInfoJson);

  //Disliked the cars
  Future<Either<ErrorModel, ResponseModel>> dislikeCarRepo(
          {required String carId}) async =>
      await Locator.instance.get<GraphQlServices>().disLikeACar(carId);

  //Unliked the cars
  Future<Either<ErrorModel, ResponseModel>> unlikeACarRepo(
          {required Map<String, dynamic> carInfoJson}) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .unlikeACar(unlikeSelectedCars: carInfoJson);

  //Delete car
  Future<Either<ErrorModel, ResponseModel>> deleteCarRepo(
          {required String carId}) async =>
      await Locator.instance.get<GraphQlServices>().deleteCar(carId: carId);

  //My Matches
  Future<Either<ErrorModel, MyMatchesResponseModel>> myMatchesRepo(
          {int? pageNo, required String userId}) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .getMyMatches(pageNo: pageNo, userId: userId);

  //list my cars
  Future<Either<ErrorModel, CarModel>> listOrUnListMyCar({
    required String carId,
    required String userId,
    required String userType,
    required String status,
  }) async {
    return await Locator.instance.get<GraphQlServices>().listOrUnListMyCar(
          carId: carId,
          userId: userId,
          userType: userType,
          status: status,
        );
  }
  ///Get Expired Premium Cars
  Future<Either<ErrorModel, GetCarsResponseModel>> getExpiredPremiumCarsRepo({
    Map<String, dynamic>? fetchMyCarJson,
  }) async =>
      await Locator.instance
          .get<GraphQlServices>()
          .getExpiredPremiumCars(filter: fetchMyCarJson);
}
