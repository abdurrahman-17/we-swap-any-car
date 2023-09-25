// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../core/configurations.dart';
import '../../model/car_model/car_added_accessories.dart';
import '../../model/car_model/car_exterior_grade.dart';
import '../../model/car_model/car_model.dart';
import '../../model/car_model/get_liked_cars_response_model.dart';
import '../../model/car_model/my_cars_response.dart';
import '../../model/error_model.dart';
import '../../model/faq/faq_model.dart';
import '../../model/get_system_configuration_model.dart';
import '../../model/my_matches/my_matches_response_model.dart';
import '../../model/need_finance/need_finance_response_model.dart';
import '../../model/other_cars_by_user/other_cars_by_user_response_model.dart';
import '../../model/questionnaire_model/questionnaire_model.dart';
import '../../model/report_issue/report_issue_model.dart';
import '../../model/report_issue/report_issue_response_model.dart';
import '../../model/response_model.dart';
import '../../model/technical_details/body_types.dart';
import '../../model/technical_details/car_colors.dart';
import '../../model/technical_details/fuel_types.dart';
import '../../model/technical_details/manufacturer.dart';
import '../../model/technical_details/technical_details.dart';
import '../../model/technical_details/transmission_type.dart';
import '../../model/transaction/transaction_model.dart';
import '../../model/user/premium_posts_model.dart';
import '../../model/user/subscription.dart';
import '../../model/user/user_model.dart';
import 'gq_call_manager.dart';
import 'queries/mutations.dart';
import 'queries/queries.dart';

class GraphQlServices {
  ///fetch user data
  Future<Either<ErrorModel, UserModel>> getCurrentUserData({
    required String key,
    required String value,
  }) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getUserDetails,
        variables: {'key': key, 'value': value},
      );
      return result.fold((error) => Left(ErrorModel(message: error.message)),
          (data) {
        if (data.containsKey('getUserDetails') &&
            data['getUserDetails'] != null) {
          final user = UserModel.fromJson(
              data['getUserDetails'] as Map<String, dynamic>);
          return Right(user);
        } else {
          return Right(UserModel(cognitoId: value));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      log("getCurrentUserDataException:$e");
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///create user
  Future<Either<ErrorModel, UserModel>> createUser(
      {required Map<String, dynamic> userData}) async {
    try {
      var result = await GraphQlCallManager.graphQlMutation(
        document: createUserQuery,
        variables: userData,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        final user =
            UserModel.fromJson(data['createUser'] as Map<String, dynamic>);
        return Right(user);
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///update user
  Future<Either<ErrorModel, UserModel>> updateUser(
      {required Map<String, dynamic> userData}) async {
    try {
      log("graphQL_service --> update user --> ${userData.toString()}");
      var result = await GraphQlCallManager.graphQlMutation(
        document: updateUserQuery,
        variables: userData,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        final user =
            UserModel.fromJson(data['updateUser'] as Map<String, dynamic>);
        return Right(user);
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///Delete user
  Future<Either<ErrorModel, ResponseModel>> deleteUser(
      {required Map<String, dynamic> userData}) async {
    try {
      log("graphQL_service --> delete user --> ${userData.toString()}");
      var result = await GraphQlCallManager.graphQlMutation(
        document: deleteUserMutation,
        variables: userData,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        return Right(ResponseModel(code: "200", message: "Deleted"));
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///create car
  Future<Either<ErrorModel, CarModel>> createCar(
      {required Map<String, dynamic> carData}) async {
    try {
      var result = await GraphQlCallManager.graphQlMutation(
        document: createCarQuery,
        variables: carData,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        final car =
            CarModel.fromJson(data['createCar'] as Map<String, dynamic>);
        return Right(car);
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///update car data
  Future<Either<ErrorModel, CarModel>> updateCar(
      {required Map<String, dynamic> carData}) async {
    try {
      var result = await GraphQlCallManager.graphQlMutation(
        document: updateCarQuery,
        variables: carData,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        final car =
            CarModel.fromJson(data['updateCar'] as Map<String, dynamic>);
        return Right(car);
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch car accessories data
  Future<Either<ErrorModel, List<ListedItem>>> fetchCarAccessories() async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getAccessoryDataQuery,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        List<ListedItem> tempCarAccessory = [];
        final result = data['getAccesoryData'] as List;
        for (final item in result) {
          tempCarAccessory
              .add(ListedItem.fromJson(item as Map<String, dynamic>));
        }
        tempCarAccessory.sort(
          (a, b) => (a.name ?? '')
              .toLowerCase()
              .compareTo((b.name ?? '').toLowerCase()),
        );
        return Right(tempCarAccessory);
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch getExteriorGradesList
  Future<Either<ErrorModel, List<ExteriorGrade>>>
      getExteriorGradesList() async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getExteriorGradesListQuery,
      );

      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        List<ExteriorGrade> tempCarExteriorGrade = [];
        final result = data['getExteriorGrade'] as List;
        for (final item in result) {
          tempCarExteriorGrade
              .add(ExteriorGrade.fromQuery(item as Map<String, dynamic>));
        }
        return Right(tempCarExteriorGrade);
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch get car manufacturer List
  Future<Either<ErrorModel, List<Manufacturers>>> getCarManufacturers() async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getManufacturerDataQuery,
      );

      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        List<Manufacturers> tempCarManufacturer = [];
        if (data.containsKey('listMasterTechnicalDetails') &&
            data['listMasterTechnicalDetails'] != null) {
          final technicalDetails =
              data['listMasterTechnicalDetails'] as Map<String, dynamic>;
          if (technicalDetails.containsKey('manufacturers') &&
              technicalDetails['manufacturers'] != null) {
            final manufacturers = technicalDetails['manufacturers'] as List;
            for (final item in manufacturers) {
              tempCarManufacturer
                  .add(Manufacturers.fromJson(item as Map<String, dynamic>));
            }
          }
        }
        return Right(tempCarManufacturer);
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch get car colors List
  Future<Either<ErrorModel, CarTechnicalDetails>> getTechnicalDetails() async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getTechnicalDetailsDataQuery,
      );

      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        List<BodyTypes> tempCarBodyTypes = [];
        List<CarColors> tempCarColors = [];
        List<FuelTypes> tempCarFuelTypes = [];
        List<TransmissionTypes> tempCartransmissionTypes = [];

        if (data.containsKey('listMasterTechnicalDetails') &&
            data['listMasterTechnicalDetails'] != null) {
          final technicalDetails =
              data['listMasterTechnicalDetails'] as Map<String, dynamic>;

          //Body Types
          if (technicalDetails.containsKey('bodyTypes') &&
              technicalDetails['bodyTypes'] != null) {
            final carBodyType = technicalDetails['bodyTypes'] as List;

            for (final item in carBodyType) {
              tempCarBodyTypes
                  .add(BodyTypes.fromJson(item as Map<String, dynamic>));
            }
          }

          //Colors
          if (technicalDetails.containsKey('carColors') &&
              technicalDetails['carColors'] != null) {
            final carColors = technicalDetails['carColors'] as List;

            for (final item in carColors) {
              tempCarColors
                  .add(CarColors.fromJson(item as Map<String, dynamic>));
            }
          }

          //Fuel Types
          if (technicalDetails.containsKey('fuelTypes') &&
              technicalDetails['fuelTypes'] != null) {
            final fuelTypes = technicalDetails['fuelTypes'] as List;

            for (final item in fuelTypes) {
              tempCarFuelTypes
                  .add(FuelTypes.fromJson(item as Map<String, dynamic>));
            }
          }

          //Transmission Types
          if (technicalDetails.containsKey('transmissionTypes') &&
              technicalDetails['transmissionTypes'] != null) {
            final carTransmissionTypes =
                technicalDetails['transmissionTypes'] as List;

            for (final item in carTransmissionTypes) {
              tempCartransmissionTypes.add(
                  TransmissionTypes.fromJson(item as Map<String, dynamic>));
            }
          }
        }

        return Right(CarTechnicalDetails(
          bodyTypes: tempCarBodyTypes,
          carColors: tempCarColors,
          fuelTypes: tempCarFuelTypes,
          transmissionTypes: tempCartransmissionTypes,
        ));
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///get system configuration
  Future<Either<ErrorModel, GetSystemConfigurationResponseModel>>
      getSystemConfigurations() async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
          document: getPriceApprovePercentage);

      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data['getSystemConfigurations'] == null) {
          return Left(ErrorModel(message: "Configuration failed"));
        } else {
          return Right(GetSystemConfigurationResponseModel.fromJson(data));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch car data
  Future<Either<ErrorModel, CarModel>> getCarDetails({
    required String key,
    required String value,
  }) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getCarDetailsQuery,
        variables: {'key': key, 'value': value},
      );
      return result.fold((error) => Left(ErrorModel(message: error.message)),
          (data) {
        if (data.containsKey('getCarDetails') &&
            data['getCarDetails'] != null) {
          final car =
              CarModel.fromJson(data['getCarDetails'] as Map<String, dynamic>);
          return Right(car);
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch view match cars
  Future<Either<ErrorModel, GetCarsResponseModel>> getCars({
    required Map<String, dynamic> listingParams,
  }) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getCarsQuery,
        variables: {
          'listingParams': listingParams,
        },
      );
      log(listingParams.toString());
      return result.fold((error) => Left(ErrorModel(message: error.message)),
          (data) {
        log("${data['getCars']['cars'].length}");
        if (data.containsKey('getCars') && data['getCars'] != null) {
          final response = GetCarsResponseModel.fromJson(
              data['getCars'] as Map<String, dynamic>);
          return Right(response);
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch my cars
  Future<Either<ErrorModel, GetCarsResponseModel>> getMyCarsWithFilter({
    Map<String, dynamic>? filter,
  }) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getMyCarsQuery,
        variables: filter ?? <String, dynamic>{},
      );
      return result.fold((error) => Left(ErrorModel(message: error.message)),
          (data) {
        if (data.containsKey('myCars') && data['myCars'] != null) {
          final response = GetCarsResponseModel.fromJson(
              data['myCars'] as Map<String, dynamic>);
          return Right(response);
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch other cars by user
  Future<Either<ErrorModel, OtherCarsByUserResponseModel>> getOtherCarsByUser(
      Map<String, dynamic> variablesJson) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getOtherCarsByUserQuery,
        variables: variablesJson,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('otherCarsByUser') &&
            data['otherCarsByUser'] != null) {
          return Right(OtherCarsByUserResponseModel.fromJson(
              data['otherCarsByUser'] as Map<String, dynamic>));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch subscription data
  Future<Either<ErrorModel, List<SubscriptionModel>>>
      fetchSubscriptions() async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getSubscriptionDataQuery,
      );
      return result.fold((error) => Left(ErrorModel(message: error.message)),
          (data) {
        if (data.containsKey('getSubscriptions') &&
            data['getSubscriptions'] != null) {
          List<SubscriptionModel> subscriptionList = [];
          for (final item in data['getSubscriptions'] as List) {
            subscriptionList
                .add(SubscriptionModel.fromJson(item as Map<String, dynamic>));
          }
          return Right(subscriptionList);
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///add subscription data
  Future<Either<ErrorModel, SubscriptionModel>> addSubscription(
      Map<String, dynamic> subscriptionData) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: addSubscriptionRequest,
        variables: subscriptionData,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('addSubscriptionRequest') &&
            data['addSubscriptionRequest'] != null) {
          return Right(SubscriptionModel.fromJson(
              data['addSubscriptionRequest'] as Map<String, dynamic>));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///Upgrade subscription data
  Future<Either<ErrorModel, SubscriptionModel>> upgradeSubscription(
      Map<String, dynamic> subscriptionData) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: upgradeSubscriptionRequest,
        variables: subscriptionData,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('upgradeSubscriptionRequest') &&
            data['upgradeSubscriptionRequest'] != null) {
          return Right(SubscriptionModel.fromJson(
              data['upgradeSubscriptionRequest'] as Map<String, dynamic>));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  //Cancel subscription
  Future<Either<ErrorModel, SubscriptionModel>> cancelSubscription(
      Map<String, dynamic> subscriptionData) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: cancelSubscriptionRequest,
        variables: subscriptionData,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('cancelSubscription') &&
            data['cancelSubscription'] != null) {
          return Right(SubscriptionModel.fromJson(
              data['cancelSubscription'] as Map<String, dynamic>));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch issue types
  Future<Either<ErrorModel, List<IssueType>>> getIssueTypesQuery() async {
    try {
      var result =
          await GraphQlCallManager.graphQlQuery(document: getIssueTypes);

      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('getDisputeTypes') &&
            data['getDisputeTypes'] != null) {
          List<IssueType> tempList = [];
          for (final item in data['getDisputeTypes'] as List) {
            tempList.add(IssueType.fromJson(item as Map<String, dynamic>));
          }
          return Right(tempList);
        }
        return Left(ErrorModel(message: errorOccurred));
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///Report issue
  Future<Either<ErrorModel, ReportIssueResponseModel>> reportIssue(
      Map<String, dynamic> reportIssueData) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: reportIssueMutation,
        variables: reportIssueData,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('reportIssue') && data['reportIssue'] != null) {
          return Right(ReportIssueResponseModel.fromJson(
              data['reportIssue'] as Map<String, dynamic>));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///Add Finance request
  Future<Either<ErrorModel, AddFinanceRequestResponseModel>> addFinanceRequest(
      Map<String, dynamic> needFinanceData) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: submitNeedFinanceRequest,
        variables: needFinanceData,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('addFinanceRequest') &&
            data['addFinanceRequest'] != null) {
          return Right(AddFinanceRequestResponseModel.fromJson(
              data['addFinanceRequest'] as Map<String, dynamic>));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///get liked cars with search
  Future<Either<ErrorModel, GetLikedCarsResponseModel>> getLikedCarsWithSearch(
      {required Map<String, dynamic> likedCarJson}) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getLikedCarsQuery,
        variables: likedCarJson,
      );
      return result.fold((error) => Left(ErrorModel(message: error.message)),
          (data) {
        if (data.containsKey('likedCars') && data['likedCars'] != null) {
          return Right(GetLikedCarsResponseModel.fromJson(
              data['likedCars'] as Map<String, dynamic>));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  //Like A car
  Future<Either<ErrorModel, ResponseModel>> likeACar(
      Map<String, dynamic> likeCarinfo) async {
    try {
      var result = await GraphQlCallManager.graphQlMutation(
        document: likeACarMutation,
        variables: likeCarinfo,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('likeACar') && data['likeACar'] != null) {
          return Right(ResponseModel(code: "200", message: "Liked"));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  //DisLike A car
  Future<Either<ErrorModel, ResponseModel>> disLikeACar(String carId) async {
    try {
      var result = await GraphQlCallManager.graphQlMutation(
        document: disLikeACarMutation,
        variables: {'carId': carId},
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('dislikeACar') && data['dislikeACar'] != null) {
          return Right(ResponseModel(code: "200", message: "Disliked"));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  //Unlike A car
  Future<Either<ErrorModel, ResponseModel>> unlikeACar(
      {required Map<String, dynamic> unlikeSelectedCars}) async {
    try {
      log("graphQL_service --> delete liked car --> $unlikeSelectedCars");
      var result = await GraphQlCallManager.graphQlMutation(
        document: unlikeACarMutation,
        variables: unlikeSelectedCars,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        return Right(ResponseModel(code: "200", message: "Deleted"));
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///Delete A car
  Future<Either<ErrorModel, ResponseModel>> deleteCar(
      {required String carId}) async {
    try {
      var result = await GraphQlCallManager.graphQlMutation(
        document: deleteCarMutation,
        variables: {'_id': carId},
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('deleteCar') && data['deleteCar'] != null) {
          return Right(
              ResponseModel(code: "200", message: "Deleted successfully"));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  // Get faq questions
  Future<Either<ErrorModel, List<FaqModel>>> getFaqQuestionsService() async {
    try {
      var result =
          await GraphQlCallManager.graphQlQuery(document: getFaqQuestionsQuery);

      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('getFaqQuestions') &&
            data['getFaqQuestions'] != null) {
          List<FaqModel> tempList = [];
          for (final item in data['getFaqQuestions'] as List) {
            tempList.add(FaqModel.fromJson(item as Map<String, dynamic>));
          }
          return Right(tempList);
        }
        return Left(ErrorModel(message: errorOccurred));
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  /// Upgrade to dealer
  Future<Either<ErrorModel, UserModel>> upgradeToDealer({
    required String planId,
    required String planName,
    required String planType,
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      var result = await GraphQlCallManager.graphQlMutation(
        document: upgradeToDealerRequest,
        variables: {
          'planId': planId,
          'planName': planName,
          'planType': planType,
          'userId': userId,
          'trader': userData,
          'upcomingPlanId': ''
        },
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        final user =
            UserModel.fromJson(data['upgradeToTrader'] as Map<String, dynamic>);
        return Right(user);
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  /// Update Notification Settings
  Future<Either<ErrorModel, UserModel>> updateNotificationSettings({
    required String status,
    required String userId,
  }) async {
    try {
      var result = await GraphQlCallManager.graphQlMutation(
        document: updateNotificationSettingsRequest,
        variables: {
          'status': status,
          'userId': userId,
          'notificationType': 'notifications'
        },
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        final user = UserModel.fromJson(
            data['updateNotificationSettings'] as Map<String, dynamic>);
        return Right(user);
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  //Delete Questionnaire get feedback Questions
  Future<Either<ErrorModel, List<QuestionnaireModel>>>
      getFeedBackQuestionsService({required String type}) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getFeedBackQuestionsQuery,
        variables: {
          'type': type,
        },
      );

      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data.containsKey('getFeedBackQuestions') &&
            data['getFeedBackQuestions'] != null) {
          List<QuestionnaireModel> tempList = [];
          for (final item in data['getFeedBackQuestions'] as List) {
            tempList
                .add(QuestionnaireModel.fromJson(item as Map<String, dynamic>));
          }
          return Right(tempList);
        }
        return Left(ErrorModel(message: errorOccurred));
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  //list car
  Future<Either<ErrorModel, CarModel>> listOrUnListMyCar({
    required String carId,
    required String userId,
    required String userType,
    required String status,
  }) async {
    try {
      var result = await GraphQlCallManager.graphQlMutation(
        document: listCarQuery,
        variables: {
          "_id": carId,
          "userType": userType,
          "status": status,
          "userId": userId
        },
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (result) {
        if (result['listCar'] != null) {
          final car =
              CarModel.fromJson(result['listCar'] as Map<String, dynamic>);
          return Right(car);
        }
        return Left(ErrorModel(message: errorOccurred));
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      log("listOrUnListMyCarException:$e");
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  Future<Either<ErrorModel, String>> updateFeedbackAnswers({
    required Map<String, dynamic> questionnaireAnswersJson,
  }) async {
    try {
      var result = await GraphQlCallManager.graphQlMutation(
        document: updateFeedbackAnswersMutation,
        variables: questionnaireAnswersJson,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        if (data['updateFeedbackAnswers'] != null) {
          return Right("${data['updateFeedbackAnswers']['_id']}");
        }
        return Left(ErrorModel(message: errorOccurred));
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch premium posts
  Future<Either<ErrorModel, PremiumPosts>> getPremiumPosts(
      {required String userType}) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        variables: {"userType": userType},
        document: getPremiumPostsQuery,
      );
      return result.fold((error) => Left(ErrorModel(message: error.message)),
          (data) {
        if (data.containsKey('getPremiumPosts') &&
            data['getPremiumPosts'] != null) {
          final user = PremiumPosts.fromJson(
              data['getPremiumPosts'] as Map<String, dynamic>);
          return Right(user);
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      log("getCurrentUserDataException:$e");
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch view match cars
  Future<Either<ErrorModel, MyMatchesResponseModel>> getMyMatches(
      {int? pageNo, required String userId}) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getMyMatchesQuery,
        variables: {
          'pageNo': pageNo ?? 0,
          'perPage': 10,
          'sortBy': 10,
          'userId': userId,
        },
      );
      return result.fold((error) => Left(ErrorModel(message: error.message)),
          (data) {
        if (data.containsKey('getMyMatches') && data['getMyMatches'] != null) {
          return Right(MyMatchesResponseModel.fromJson(
              data['getMyMatches'] as Map<String, dynamic>));
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch view match cars
  Future<Either<ErrorModel, num>> getActiveUsers() async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getActiveUsersCountQuery,
      );

      return result.fold((error) => Left(ErrorModel(message: errorOccurred)),
          (data) {
        num activeUsers = 0;
        if (data.containsKey('activeUsersCount') &&
            data['activeUsersCount'] != null) {
          final json = data['activeUsersCount'] as Map<String, dynamic>;
          activeUsers = json['count'] as num;
          return Right(activeUsers);
        } else {
          return Right(activeUsers);
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  ///fetch expired premium cars
  Future<Either<ErrorModel, GetCarsResponseModel>> getExpiredPremiumCars({
    Map<String, dynamic>? filter,
  }) async {
    try {
      var result = await GraphQlCallManager.graphQlQuery(
        document: getExpiredCarQuery,
        variables: filter ?? <String, dynamic>{},
      );
      return result.fold((error) => Left(ErrorModel(message: error.message)),
          (data) {
        if (data.containsKey('expiredPremiumCars') &&
            data['expiredPremiumCars'] != null) {
          final response = GetCarsResponseModel.fromJson(
              data['expiredPremiumCars'] as Map<String, dynamic>);
          return Right(response);
        } else {
          return Left(ErrorModel(message: errorOccurred));
        }
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  Future<Either<ErrorModel, TransactionModel>> updateTransactionStatus(
      {required Map<String, dynamic> transactionData}) async {
    try {
      var result = await GraphQlCallManager.graphQlMutation(
        document: updateTransactionStatusQuery(),
        variables: transactionData,
      );
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        final success = TransactionModel.fromJson(data);
        return Right(success);
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }

  Future<Either<ErrorModel, TransactionModel>> createTransaction(
      {required Map<String, dynamic> transactionData}) async {
    try {
      String query = createTransactionQuery();
      log("query: $query , parameter: $transactionData");
      var result = await GraphQlCallManager.graphQlMutation(
        document: createTransactionQuery(),
        variables: transactionData,
      );
      log("transaction data $result");
      return result.fold((error) {
        return Left(ErrorModel(message: error.message));
      }, (data) {
        log("transaction data $data");
        final success = TransactionModel.fromJson(
            data['createTransaction'] as Map<String, dynamic>);
        return Right(success);
      });
    } catch (e, s) {
      sentryExceptionCapture(throwable: e, stackTrace: s);
      return Left(ErrorModel(message: errorOccurred));
    }
  }
}
