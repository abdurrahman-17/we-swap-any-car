import 'package:easy_refresh/easy_refresh.dart';
import 'package:wsac/presentation/my_cars/widgets/filter_my_car_bottomsheet.dart';

import '../../bloc/list_unlist/list_unlist_bloc_bloc.dart';
import '../../core/configurations.dart';
import '../../bloc/my_cars/my_cars_bloc.dart';
import '../../main.dart';
import '../../model/car_model/car_model.dart';
import '../../model/car_model/value_section_input.dart';
import '../../model/technical_details/manufacturer.dart';
import '../../utility/debouncer.dart';
import '../add_car/add_car_stepper_screen.dart';
import '../common_widgets/common_admin_support_button.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../error_screen/error_widget.dart';
import 'widgets/my_car_profile_widget.dart';
import '../../utility/common_keys.dart' as key;

class MyCarsScreen extends StatefulWidget {
  static const String routeName = 'my_cars_screen';
  const MyCarsScreen({
    Key? key,
    this.drawerOnTap,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.car,
  }) : super(key: key);

  final VoidCallback? drawerOnTap;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final CarModel? car;

  @override
  State<MyCarsScreen> createState() => _MyCarsScreenState();
}

class _MyCarsScreenState extends State<MyCarsScreen> {
  List<CarModel> myCars = [];
  bool isGuest = false;
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<String> suffixIcon = ValueNotifier<String>('');
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  Map<String, dynamic> filterJsonData = {};
  Map<String, dynamic> selectedFilter = {};

  int perPage = 10;
  int pageNo = 0;

  @override
  void initState() {
    fetchMyCars();
    super.initState();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future<void> fetchMyCars() async {
    pageNo = 0;
    if (filterJsonData.isNotEmpty) {
      filterJsonData['search'] = searchController.text.trim();
    } else {
      filterJsonData = {'search': searchController.text.trim()};
    }
    final Map<String, dynamic> myCarJson = {
      'pageNo': pageNo,
      'perPage': perPage,
      'filters': filterJsonData,
    };
    BlocProvider.of<MyCarsBloc>(context)
        .add(GetMyCarsEvent(fetchMyCarjson: myCarJson));
  }

  Future<void> getLoadMoreCars() async {
    final Map<String, dynamic> myCarJson = {
      'pageNo': ++pageNo,
      'perPage': perPage,
      'filters': filterJsonData,
    };
    context
        .read<MyCarsBloc>()
        .add(GetMoreMyCarsEvent(fetchMoreMyCarJson: myCarJson));
  }

  ///search
  Future<void> search() async =>
      _debouncer.run(() async => await fetchMyCars());

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListUnlistBlocBloc, ListUnlistBlocState>(
      listener: (context, state) {
        if (state is DeleteMyCarState &&
            state.routeName == MyCarsScreen.routeName) {
          if (state.deleteStatus == ProviderStatus.success) {
            setLoader(false);
            fetchMyCars();
          } else if (state.deleteStatus == ProviderStatus.error) {
            setLoader(false);
            showSnackBar(message: state.errorMessage ?? '');
          } else {
            setLoader(true);
          }
        }
      },
      child: CustomDrawerScaffold(
        backgroundColor: ColorConstant.kBackgroundColor,
        title: myCarsNavAppBar,
        drawerOnTap: widget.drawerOnTap,
        actions: [
          AdminSupportButton(isGuest: isGuest),
        ],
        body: Stack(
          children: [
            CustomImageView(
              alignment: Alignment.bottomCenter,
              svgPath: Assets.homeBackground,
              width: size.width,
              fit: BoxFit.fitWidth,
            ),
            Column(
              children: [
                Padding(
                  padding: getPadding(left: 24.w, right: 24.w, bottom: 5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      searchField(),
                      CustomImageView(
                        svgPath: Assets.filterFunnelIcon,
                        fit: BoxFit.scaleDown,
                        margin: getMargin(left: 10.w),
                        onTap: () async {
                          callFilterBottomSheet();
                        },
                      ),
                    ],
                  ),
                ),
                BlocConsumer<MyCarsBloc, MyCarsState>(
                  listener: (context, state) {
                    if (state is GetMoreMyCarsState &&
                        state.moreMyCarsStatus == ProviderStatus.success) {
                      myCars.addAll(state.moreMyCars?.cars ?? []);
                      _easyRefreshController.finishLoad(
                          IndicatorResult.success, true);
                    } else {
                      _easyRefreshController.finishLoad(
                          IndicatorResult.noMore, true);
                    }
                  },
                  builder: (context, state) {
                    if (state is GetMyCarsState) {
                      if (state.myCarsStatus == ProviderStatus.success) {
                        myCars = List.from(state.myCars?.cars ?? []);
                        return myCarListWidget(myCars);
                      } else if (state.myCarsStatus == ProviderStatus.error) {
                        return Expanded(
                          child: Container(
                            alignment: Alignment.topCenter,
                            margin: getMargin(top: size.height * 0.15),
                            height: size.height,
                            child: ErrorWithButtonWidget(
                              message: errorOccurred,
                              buttonLabel: retryButton,
                              onTap: () async => await fetchMyCars(),
                            ),
                          ),
                        );
                      }
                    } else if (state is GetMoreMyCarsState) {
                      return myCarListWidget(myCars);
                    }
                    return shimmerList();
                  },
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: widget.floatingActionButton,
        bottomNavigationBar: widget.bottomNavigationBar,
      ),
    );
  }

  Widget shimmerList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        padding: getPadding(left: 20.w, right: 20.w, top: 10.h),
        itemBuilder: (ctx, index) {
          return shimmerLoader(
            AspectRatio(
              aspectRatio: 1.6,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                margin: getMargin(top: 5.h, bottom: 5.h),
                decoration: BoxDecoration(
                  color: ColorConstant.kColorWhite,
                  borderRadius: BorderRadius.circular(21.r),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget searchField() {
    return Expanded(
      child: CommonTextFormField(
        autoValidate: AutovalidateMode.disabled,
        onChanged: (searchPattern) async {
          suffixIcon.value = searchPattern;
          await search();
        },
        controller: searchController,
        hint: searchMakeAndModelHint,
        suffixIcon: ValueListenableBuilder<String>(
          valueListenable: suffixIcon,
          builder: (BuildContext context, String searchText, Widget? child) {
            return IconButton(
              onPressed: searchText.isNotEmpty
                  ? () async {
                      searchController.clear();
                      suffixIcon.value = '';
                      await search();
                    }
                  : null,
              icon: Icon(
                searchText.isNotEmpty ? Icons.clear : Icons.search_outlined,
                color: ColorConstant.kColor7C7C7C,
              ),
            );
          },
        ),
      ),
    );
  }

  //filter bottom sheet
  Future<void> callFilterBottomSheet() async {
    final response =
        await filterMyCarBottomSheet(selectedFilter) as Map<String, dynamic>?;
    if (response != null) {
      if (response.isNotEmpty) {
        selectedFilter = response;
        filterJsonData = getFilteredData(response);
      } else {
        filterJsonData = selectedFilter = response;
      }
      await fetchMyCars();
    }
  }

  Map<String, dynamic> getFilteredData(Map<String, dynamic> response) {
    Map<String, dynamic> json = {};
    if (response.containsKey(key.makers)) {
      List<String> temp = [];
      for (final Manufacturers item
          in response[key.makers] as List<Manufacturers>) {
        temp.add(item.id ?? '');
      }
      json[key.makers] = temp;
    }
    if (response.containsKey(key.model)) {
      List<String> temp = [];
      for (final BrandModel item in response[key.model] as List<BrandModel>) {
        temp.add(item.name ?? '');
      }
      json[key.model] = temp;
    }
    if (response.containsKey(key.bodyType)) {
      List<String> temp = [];
      for (final ValuesSectionInput item
          in response[key.bodyType] as List<ValuesSectionInput>) {
        temp.add(item.id ?? '');
      }
      json[key.bodyType] = temp;
    }
    if (response.containsKey(key.year)) {
      json[key.year] = response[key.year];
    }
    if (response.containsKey(key.priceFilterKey)) {
      json[key.priceFilterKey] = response[key.priceFilterKey];
    }
    if (response.containsKey(key.transmissionType)) {
      List<String> temp = [];
      for (final ValuesSectionInput item
          in response[key.transmissionType] as List<ValuesSectionInput>) {
        temp.add(item.id ?? '');
      }
      json[key.transmissionType] = temp;
    }
    if (response.containsKey(key.fuelType)) {
      List<String> temp = [];
      for (final ValuesSectionInput item
          in response[key.fuelType] as List<ValuesSectionInput>) {
        temp.add(item.id ?? '');
      }
      json[key.fuelType] = temp;
    }
    if (response.containsKey(key.statusType)) {
      List<String> temp = [];
      for (final CarStatus item
          in response[key.statusType] as List<CarStatus>) {
        temp.add(item.name);
      }
      json[key.statusType] = temp;
    }
    return json;
  }

  Widget myCarListWidget(List<CarModel> myCarsList) {
    return myCarsList.isNotEmpty
        ? Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: EasyRefresh(
                triggerAxis: Axis.vertical,
                clipBehavior: Clip.none,
                controller: _easyRefreshController,
                footer: ClassicFooter(
                  textStyle: AppTextStyle.regularTextStyle.copyWith(
                    color: ColorConstant.kColor7C7C7C,
                    fontWeight: FontWeight.w700,
                  ),
                  hapticFeedback: true,
                  noMoreIcon: Icon(
                    Icons.low_priority_sharp,
                    color: ColorConstant.kColor7C7C7C,
                  ),
                  dragText: 'Load More',
                  failedText: 'No More',
                  processingText: 'Loading..',
                  readyText: 'No More',
                  noMoreText: 'No More',
                ),
                onLoad: () => getLoadMoreCars(),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: myCarsList.length,
                  itemBuilder: (ctx, index) => MyCarProfileWidget(
                    car: myCarsList[index],
                    onTapRemove: () => onTapRemove(myCarsList[index]),
                    onTapResume: () => Navigator.pushNamed(
                      context,
                      AddCarStepperScreen.routeName,
                      arguments: {'carModel': myCarsList[index]},
                    ),
                  ),
                ),
              ),
            ),
          )
        : Expanded(
            child: Container(
              alignment: Alignment.center,
              height: getVerticalSize(size.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    svgPath: Assets.bottomAddCar,
                    height: getSize(50),
                    width: getSize(50),
                    onTap: () => Navigator.pushNamed(
                        context, AddCarStepperScreen.routeName),
                  ),
                  Padding(
                    padding: getPadding(top: 25.h, bottom: 39.h),
                    child: Text(
                      pleaseAddYourCar,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        fontSize: getFontSize(16),
                        color: ColorConstant.kColor606060,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Future<void> onTapRemove(CarModel car) async {
    bool result = await confirmationPopup(
      title: confirmButton,
      message: deletePostConfirm,
      isQuestion: true,
    );
    if (result) {
      if (!mounted) return;
      BlocProvider.of<ListUnlistBlocBloc>(context).add(
          DeleteMyCarEvent(carId: car.id!, routeName: MyCarsScreen.routeName));
    }
  }

  void setLoader(bool isLoader) {
    if (isLoader) {
      progressDialogue();
    } else {
      Navigator.pop(globalNavigatorKey.currentContext!);
    }
  }
}
