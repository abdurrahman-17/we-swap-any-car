import '../../bloc/car_details/car_details_bloc.dart';
import '../../core/configurations.dart';
import '../../helpers/add_car_stepper_helper.dart';
import '../../model/add_car/common_step_model.dart.dart';
import '../../model/car_model/car_model.dart';
import '../common_widgets/animated_gradient_progress_bar.dart';
import '../common_widgets/common_admin_support_button.dart';
import '../common_widgets/common_divider.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/processing_step_tile.dart';
import '../landing_screen/landing_screen.dart';
import 'car_summary/car_summary.dart';
import 'screens/add_information.dart';
import 'screens/check_car_valuation/check_car_worth.dart';
import 'screens/condition_and_damage.dart';
import 'screens/hpi_and_mot.dart';
import 'screens/service_history.dart';
import 'upload_images_video/upload_photos_and_videos_steps.dart';

class AddCarStepperScreen extends StatefulWidget {
  static const String routeName = 'add_car_stepper_scren';
  const AddCarStepperScreen({
    Key? key,
    this.carModel,
  }) : super(key: key);

  final CarModel? carModel;

  @override
  State<AddCarStepperScreen> createState() => _AddCarStepperScreenState();
}

class _AddCarStepperScreenState extends State<AddCarStepperScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> _progressAnimation;
  late AnimationController _progressAnimcontroller;

  double? growStepWidth, beginWidth, endWidth = 0.0;
  bool isCompleted = false;
  List<int> completedIndex = [];
  CarModel? carModel;
  List<CommonStepsModel> stepperData = [];

  @override
  void initState() {
    stepperData = AddCarStepperHelper.stepperData;
    isCompleted = ((widget.carModel?.createStatus ?? [])
        .contains(convertEnumToString(CarCreateStatus.completed)));
    _progressAnimcontroller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _progressAnimation =
        Tween<double>(begin: 0, end: 0).animate(_progressAnimcontroller);

    if (widget.carModel != null) {
      carModel = widget.carModel;
      fetchStatusAndSetProgress(widget.carModel);
    }
    super.initState();
  }

  void fetchStatusAndSetProgress(CarModel? car) {
    if (car?.createStatus != null && car!.createStatus!.isNotEmpty) {
      completedIndex = [];
      final createList = car.createStatus!.toSet().toList();
      for (int i = 0; i < CarCreateStatus.values.length; i++) {
        if (createList.contains(CarCreateStatus.values[i].name)) {
          completedIndex.add(i);
        }
      }
      if (createList.contains(CarCreateStatus.completed.name)) {
        setProgressAnim(size.width, completedIndex.length - 1);
      } else {
        setProgressAnim(size.width, completedIndex.length);
      }
    }
  }

  void setProgressAnim(double maxWidth, int curPageIndex) {
    growStepWidth = maxWidth / stepperData.length;
    beginWidth = growStepWidth! * (curPageIndex - 1);
    endWidth = growStepWidth! * curPageIndex;

    _progressAnimation = Tween<double>(begin: beginWidth, end: endWidth)
        .animate(_progressAnimcontroller);
    _progressAnimcontroller.forward();
  }

  void completedIndexAddFunction(Map<String, dynamic>? result) {
    if (result != null) {
      carModel = result['carModel'] as CarModel;
      setState(() {});
      fetchStatusAndSetProgress(carModel);
    }
  }

  Future<void> navigateToStep({
    required String routeName,
    required Map<String, dynamic> arguments,
  }) async {
    final Object? result =
        await Navigator.pushNamed(context, routeName, arguments: arguments);

    completedIndexAddFunction(result as Map<String, dynamic>?);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarDetailsBloc, CarDetailsState>(
      listener: (context, state) async {
        if (state is UpdateCarInfoState &&
            state.carCreateStatus == CarCreateStatus.stepperScreen) {
          if (state.updateCarStatus == ProviderStatus.success) {
            Navigator.pop(context);
            CarModel? car = state.car;

            final result = await Navigator.pushNamed(
              context,
              CarSummaryScreen.routeName,
              arguments: {'carId': car?.id ?? ''},
            );

            if (result != null) {
              final Map<String, dynamic> json = result as Map<String, dynamic>;
              setState(() {
                carModel = json['carModel'] as CarModel;
              });
            }
          } else if (state.updateCarStatus == ProviderStatus.error) {
            Navigator.pop(context);
            showSnackBar(message: state.errorMessage ?? '');
          } else {
            progressDialogue();
          }
        }
      },
      child: CustomScaffold(
        title: addCarScreenAppBar,
        actions: const [
          AdminSupportButton(),
        ],
        body: SafeArea(
          child: Column(
            children: [
              CustomImageView(
                width: MediaQuery.of(context).size.width,
                svgPath: Assets.addCarTopColorBg,
              ),
              AnimatedProgressBar(
                height: getVerticalSize(3.h),
                animation: _progressAnimation,
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: stepperData.length,
                    padding: getPadding(
                      left: 20.w,
                      right: 20.w,
                      top: 8.h,
                      bottom: 8.h,
                    ),
                    itemBuilder: (context, index) {
                      return ProcessingTile(
                        hasStepBadge: true,
                        stepNumber: index + 1,
                        title: stepperData[index].title,
                        isEnabled: completedIndex.contains(0) || index == 0,
                        subTitle: stepperData[index].subTitle,
                        isMandatory: false,
                        status: completedIndex.contains(index)
                            ? ProgressStatus.completed
                            : null,
                        onTap: () async {
                          if (index == 0) {
                            navigateToStep(
                              routeName: CheckCarWorthScreen.routeName,
                              arguments: {'carModel': carModel},
                            );
                          } else if (completedIndex.contains(0) && index == 1) {
                            navigateToStep(
                              routeName: AddInformationScreen.routeName,
                              arguments: {'carModel': carModel},
                            );
                          } else if (completedIndex.contains(0) && index == 2) {
                            navigateToStep(
                              routeName: HPIAndMOTScreen.routeName,
                              arguments: {'carModel': carModel},
                            );
                          } else if (completedIndex.contains(0) && index == 3) {
                            navigateToStep(
                              routeName: ServiceHistoryScreen.routeName,
                              arguments: {'carModel': carModel},
                            );
                          } else if (completedIndex.contains(0) && index == 4) {
                            navigateToStep(
                              routeName: ConditionAndDamageScreen.routeName,
                              arguments: {'carModel': carModel},
                            );
                          } else if (completedIndex.contains(0) && index == 5) {
                            navigateToStep(
                              routeName:
                                  UploadPhotosAndVideosStepScreen.routeName,
                              arguments: {'carModel': carModel},
                            );
                          }
                        },
                      );
                    },
                    separatorBuilder: (context, index) => CommonDivider(
                      color: ColorConstant.kColorC7C7C7,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: getPadding(
                  left: 20.w,
                  right: 20.w,
                  top: 10.h,
                  bottom: 15.h,
                ),
                child: Column(
                  children: [
                    GradientElevatedButton(
                      title: isCompleted ? saveYourCar : startListingYourCar,
                      onTap: isCompleted || completedIndex.length >= 6
                          ? () async {
                              if (isCompleted) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    LandingScreen.routeName,
                                    arguments: {"selectedIndex": 0},
                                    (route) => false);
                              } else if (completedIndex.length >= 6) {
                                onTapStartListingCar();
                              }
                            }
                          : null,
                    ),
                    // Skip for now Button
                    Padding(
                      padding: getPadding(top: 15.h),
                      child: GestureDetector(
                        onTap: () {
                          if (completedIndex.isEmpty) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              LandingScreen.routeName,
                              (route) => false,
                            );
                          } else {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              LandingScreen.routeName,
                              arguments: {"selectedIndex": 0},
                              (route) => false,
                            );
                          }
                        },
                        child: Text(
                          skipForNowButton,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppTextStyle.regularTextStyle.copyWith(
                            color: ColorConstant.kColor646464,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onTapStartListingCar() async {
    if (!completedIndex.contains(0)) {
      showSnackBar(message: 'Please complete car valuation');
    } else if (!completedIndex.contains(1)) {
      showSnackBar(message: 'Please add information about your car');
    } else if (!completedIndex.contains(2)) {
      showSnackBar(message: 'Please add HPI & MOT details');
    } else if (!completedIndex.contains(3)) {
      showSnackBar(message: 'Please add service history details');
    } else if (!completedIndex.contains(4)) {
      showSnackBar(message: 'Please fill condition and damage details');
    } else if (!completedIndex.contains(5)) {
      showSnackBar(message: 'Please upload photos');
    } else {
      List<String> createStatus = carModel?.createStatus ?? [];
      createStatus.add(convertEnumToString(CarCreateStatus.completed));

      BlocProvider.of<CarDetailsBloc>(context).add(
        UpdateCarInfoEvent(
          carInfoData: {
            '_id': carModel?.id,
            'createStatus': createStatus.toSet().toList(),
          },
          carCreateStatus: CarCreateStatus.stepperScreen,
        ),
      );
    }
  }
}
