import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wsac/model/car_model/car_model.dart';

import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/liked_cars/liked_car_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../model/car_model/liked_car_model.dart';
import '../../model/car_model/value_section_input.dart';
import '../../model/chat_model/chat_group/chat_car_model.dart';
import '../../model/chat_model/chat_group/chat_group_model.dart';
import '../../model/chat_model/chat_group/chat_user_model.dart';
import '../../model/technical_details/manufacturer.dart';
import '../../model/user/user_model.dart';
import '../../service/deep_link_service.dart';
import '../../utility/chat_utils.dart';
import '../../utility/common_keys.dart' as key;
import '../../utility/date_time_utils.dart';
import '../../utility/debouncer.dart';
import '../chat_screen/screens/user_chat_window.dart';
import '../common_popup_widget/decription_popup.dart';
import '../common_widgets/common_chat.dart';
import '../common_widgets/common_gradient_label.dart';
import '../common_widgets/common_like_with_count.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../common_widgets/common_quick_offer_banner.dart';
import '../common_widgets/common_share_widget.dart';
import '../error_screen/error_widget.dart';
import '../view_match_car/car_profile.dart';
import '../view_match_car/view_profile.dart';
import 'widgets/filter_liked_car_bottomsheet.dart';

class LikedCarsScreen extends StatefulWidget {
  static const String routeName = "liked_cars_screen";
  const LikedCarsScreen({
    Key? key,
    this.drawerOnTap,
    this.floatingActionButton,
    this.bottomNavigationBar,
  }) : super(key: key);

  final VoidCallback? drawerOnTap;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  State<LikedCarsScreen> createState() => _LikedCarsScreenState();
}

class _LikedCarsScreenState extends State<LikedCarsScreen> {
  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<String> suffixIcon = ValueNotifier<String>('');
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  bool isDelete = false;
  UserModel? currentUserData;
  int pageNo = 0;
  int perPage = 10;
  Map<String, dynamic> filterJsonData = {};
  Map<String, dynamic> selectedFilter = {};
  late LikedCarsBloc likedCarsBloc;
  List<String> toDeleteList = [];
  List<LikedCarModel> myLikedCars = [];
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  late String userOrTraderId;

  @override
  void initState() {
    likedCarsBloc = BlocProvider.of<LikedCarsBloc>(context);
    currentUserData = context.read<UserBloc>().currentUser;
    userOrTraderId =
        currentUserData!.userType == convertEnumToString(UserType.private)
            ? currentUserData!.userId!
            : currentUserData!.traderId!;
    fetchLikedCar();
    super.initState();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future<void> fetchLikedCar() async {
    pageNo = 0;
    perPage = 10;

    final Map<String, dynamic> likedCarJson = {
      'pageNo': pageNo,
      'perPage': perPage,
      'sortBy': -1,
      'userId': userOrTraderId,
      'search': searchController.text,
      'filters': filterJsonData,
    };
    likedCarsBloc.add(GetLikedCarsEvent(likedCarJson: likedCarJson));
  }

  void getLoadMoreLikedCars() async {
    final Map<String, dynamic> likedCarJson = {
      'pageNo': ++pageNo,
      'perPage': perPage,
      'sortBy': -1,
      'userId': userOrTraderId,
      'search': searchController.text,
      'filters': filterJsonData,
    };
    likedCarsBloc.add(GetMoreLikedCarsEvent(likedCarJson: likedCarJson));
  }

  ///search
  void search(String searchPattern) async {
    _debouncer.run(() => fetchLikedCar());
  }

  Future<void> unlikeCars({bool isDeleteAll = false}) async {
    bool result = await confirmationPopup(
      title: confirmTitle,
      message: areYouSureWantToDelete,
      messageTextAlign: TextAlign.center,
      isQuestion: true,
    );
    if (isDeleteAll) {
      toDeleteList.clear();
      for (var element in myLikedCars) {
        toDeleteList.add(element.carId ?? '');
      }
    }
    if (result) {
      final Map<String, dynamic> myDeleteLikedCars = {
        'carId': toDeleteList,
        'userId': userOrTraderId,
        'deleteAll': isDeleteAll
      };
      if (toDeleteList.isNotEmpty) {
        likedCarsBloc
            .add(UnLikeACarEvent(unlikeSelectedCars: myDeleteLikedCars));
      }
    }
  }

  void setLoading(bool value) {
    if (value) {
      progressDialogue();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatGroupCreateState &&
            state.routeName == CarProfileScreen.routeName) {
          if (state.createChatGroupStatus == ProviderStatus.success) {
            setLoading(false);
            Navigator.pushNamed(
              context,
              UserChatScreen.routeName,
              arguments: {
                'chatGroup': state.chatGroup,
                'userIdOrAdminUserId': userOrTraderId,
                'selectedIndex': state.selectedIndex,
              },
            );
          } else if (state.createChatGroupStatus == ProviderStatus.error) {
            setLoading(false);
            showSnackBar(message: state.errorMessage ?? errorOccurred);
          } else {
            setLoading(true);
          }
        }
      },
      child: CustomDrawerScaffold(
        title: likedCarNavAppBar,
        drawerOnTap: widget.drawerOnTap,
        actions: [
          CustomImageView(
            svgPath: Assets.trashIcon,
            fit: BoxFit.scaleDown,
            color: ColorConstant.kColor7C7C7C,
            margin: getMargin(right: 20.w),
            onTap: () {
              if (myLikedCars.isEmpty) {
                showSnackBar(message: "No liked cars to delete!");
              } else {
                setState(() {
                  isDelete = !isDelete;
                  if (!isDelete) {
                    toDeleteList.clear();
                  }
                });
              }
            },
          ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      searchBox(),
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
                if (isDelete)
                  Padding(
                    padding: getPadding(top: 15.h, left: 30.w),
                    child: const Text(deleteText),
                  ),
                SizedBox(
                  height: 5.h,
                ),
                BlocConsumer<LikedCarsBloc, LikedCarsState>(
                  listener: (context, state) {
                    if (state is GetMoreLikedCarsState &&
                        state.moreLikedCarStatus == ProviderStatus.success) {
                      if (state.moreLikedCarsList?.cars != null &&
                          state.moreLikedCarsList!.cars!.isNotEmpty) {
                        myLikedCars.addAll(state.moreLikedCarsList!.cars!);
                        _easyRefreshController.finishLoad(
                            IndicatorResult.success, true);
                      } else {
                        _easyRefreshController.finishLoad(
                            IndicatorResult.noMore, true);
                      }
                    } else if (state is UnLikeACarState) {
                      if (state.likedCarDataDeleteStatus ==
                          ProviderStatus.success) {
                        toDeleteList.clear;
                        setLoader(false);
                        fetchLikedCar();
                        setState(() {
                          isDelete = false;
                        });
                      } else if (state.likedCarDataDeleteStatus ==
                          ProviderStatus.error) {
                        setLoader(false);
                        showSnackBar(message: state.errorMessage ?? '');
                      } else {
                        setLoader(true);
                      }
                    }
                  },
                  builder: (context, state) {
                    //inital cars
                    if (state is GetLikedCarsState &&
                        state.likedCarsStatus == ProviderStatus.success) {
                      myLikedCars = List.from(state.likedCarsList?.cars ?? []);
                      return bodyData(myLikedCars);
                    } //more cars
                    else if (state is GetMoreLikedCarsState) {
                      return bodyData(myLikedCars);
                    } //error
                    else if (state is GetLikedCarsState &&
                        state.likedCarsStatus == ProviderStatus.error) {
                      return Expanded(
                        child: Container(
                          alignment: Alignment.topCenter,
                          margin: getMargin(top: size.height * 0.15),
                          height: size.height,
                          child: ErrorWithButtonWidget(
                            message: errorOccurredWhileFetch,
                            buttonLabel: retryButton,
                            onTap: fetchLikedCar,
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 3,
                        padding: getPadding(
                          left: 20.w,
                          right: 20.w,
                          top: 10.h,
                        ),
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
                  },
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: !isDelete ? widget.floatingActionButton : null,
        bottomNavigationBar:
            !isDelete ? widget.bottomNavigationBar : deleteButtons(),
      ),
    );
  }

  Widget searchBox() {
    return Expanded(
      child: CommonTextFormField(
        autoValidate: AutovalidateMode.disabled,
        onChanged: (searchPattern) {
          search(searchPattern);
          suffixIcon.value = searchPattern;
        },
        controller: searchController,
        hint: searchMakeAndModelHint,
        suffixIcon: ValueListenableBuilder<String>(
          valueListenable: suffixIcon,
          builder: (BuildContext context, String searchText, Widget? child) {
            return IconButton(
              onPressed: searchText.isNotEmpty
                  ? () {
                      searchController.clear();
                      suffixIcon.value = '';
                      search('');
                    }
                  : null,
              icon: Icon(
                searchText.isNotEmpty ? Icons.clear : Icons.search_outlined,
                color: Colors.grey.shade600,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bodyData(List<LikedCarModel> myLikedCars) {
    if (myLikedCars.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 4,
          ),
          Center(
            child: CustomImageView(
              svgPath: Assets.bottomLike,
              height: getSize(50),
              width: getSize(50),
            ),
          ),
          Padding(
            padding: getPadding(top: 25.h, bottom: 39.h),
            child: Text(
              "No cars available",
              style: AppTextStyle.regularTextStyle.copyWith(
                fontSize: getFontSize(16),
                color: ColorConstant.kColor606060,
              ),
            ),
          ),
        ],
      );
    }
    return Expanded(
      child: body(myLikedCars),
    );
  }

  Widget deleteButtons() {
    return SizedBox(
      height: 60.h,
      child: Padding(
        padding: getPadding(bottom: 15.w, left: 25.w, right: 25.w),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CustomElevatedButton(
                  onTap: () async {
                    unlikeCars(isDeleteAll: true);
                  },
                  title: deleteAllTitle,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: GradientElevatedButton(
                  onTap: () async {
                    if (toDeleteList.isEmpty) {
                      showSnackBar(
                        message: 'Please select atleast one item to delete!',
                      );
                    } else {
                      unlikeCars();
                    }
                  },
                  title: "DELETE (${toDeleteList.length})",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget body(List<LikedCarModel> likedCarsList) {
    return Padding(
      padding: getPadding(left: 20.w, right: 20.w),
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
          onLoad: getLoadMoreLikedCars,
          child: ListView.builder(
            shrinkWrap: true,
            padding: isDelete ? getPadding(bottom: 65) : null,
            itemCount: likedCarsList.length,
            itemBuilder: (ctx, index) {
              return carProfileWidget(likedCarsList[index], index);
            },
          ),
        ),
      ),
    );
  }

  Widget carProfileWidget(LikedCarModel carModel, int index) {
    return GestureDetector(
      onTap: () {
        if (isDelete) {
          if (toDeleteList.contains(carModel.carId)) {
            toDeleteList.remove(carModel.carId);
          } else {
            toDeleteList.add(carModel.carId ?? '');
          }
          setState(() {});
        } else {
          if (carModel.status != convertEnumToString(CarStatus.sold)) {
            Navigator.pushNamed(
              context,
              ViewProfileScreen.routeName,
              arguments: {'carId': carModel.carId},
            );
          }
        }
      },
      child: Padding(
        padding: getPadding(bottom: 10.h, top: 15.h),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21.r),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  carModel.image != null
                      ? AspectRatio(
                          aspectRatio: 1.8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(21.r),
                              topRight: Radius.circular(21.r),
                            ),
                            child: imageView(carModel),
                          ),
                        )
                      : AspectRatio(
                          aspectRatio: 1.8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(21.r),
                              topRight: Radius.circular(21.r),
                            ),
                            child: Container(
                              color: ColorConstant.kColor7C7C7C,
                              child: CustomImageView(
                                svgPath: Assets.imageNotFoundSvg,
                                color: ColorConstant.kColorWhite,
                              ),
                            ),
                          ),
                        ),
                  bottomMenuOption(carModel),
                  carDetails(carModel),
                ],
              ),
              if ((isDelete && toDeleteList.contains(carModel.carId)) ||
                  (carModel.status == convertEnumToString(CarStatus.sold)))
                Positioned(
                  bottom: 0,
                  top: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (isDelete) {
                        if (toDeleteList.contains(carModel.carId)) {
                          toDeleteList.remove(carModel.carId);
                        } else {
                          toDeleteList.add(carModel.carId ?? '');
                        }
                        setState(() {});
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(21.r)),
                        color: ColorConstant.kColorBlack.withOpacity(0.8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!toDeleteList.contains(carModel.carId) &&
                              carModel.status ==
                                  convertEnumToString(CarStatus.sold))
                            GradientLabel(
                              height: 30,
                              width: 90,
                              text: soldLabel,
                              textStyle: AppTextStyle.regularTextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                fontFamily: Assets.secondaryFontOswald,
                                fontSize: getFontSize(16),
                                color: ColorConstant.kColorWhite,
                              ),
                            ),
                          if (isDelete && toDeleteList.contains(carModel.carId))
                            CustomImageView(
                              height: 35,
                              imagePath: Assets.checkIcon,
                            ),
                          if (isDelete && toDeleteList.contains(carModel.carId))
                            Padding(
                              padding: getPadding(top: 5.h),
                              child: Text(
                                selectedLabel,
                                style: AppTextStyle.txtInterRegular12,
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageView(LikedCarModel carModel) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomImageView(
          url: carModel.image ?? '',
          fit: BoxFit.contain,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: <Color>[
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: <Color>[
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Positioned(
          top: 22,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                carModel.userType == UserType.private.name
                    ? carModel.userName ?? shortAppName
                    : carModel.companyName ?? shortAppName,
                style: AppTextStyle.regularTextStyle.copyWith(
                  color: ColorConstant.kColorF27B79,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (carModel.userType != UserType.private.name)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: RatingBar.builder(
                    initialRating: carModel.companyRating?.toDouble() ?? 0.0,
                    minRating: 1,
                    allowHalfRating: true,
                    itemSize: 14,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    unratedColor: ColorConstant.kColorDBDBDB,
                    ignoreGestures: true,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: ColorConstant.kColorFFC32A,
                    ),
                    onRatingUpdate: (double value) {},
                  ),
                ),
            ],
          ),
        ),
        if (carModel.postType != null &&
            carModel.postType == convertEnumToString(CarPostType.premium))
          Positioned(
            top: 22,
            right: 20,
            child: CustomImageView(
              svgPath: Assets.premium,
              height: getVerticalSize(30.h),
            ),
          ),
        if (carModel.quickSale ?? false) const QuickOfferBanner(),
      ],
    );
  }

  Widget bottomMenuOption(LikedCarModel carModel) {
    return Padding(
      padding: getPadding(
        top: 16.h,
        left: 19.w,
        right: 19.w,
        bottom: 12.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LikeWithCount(
            isSliderOption: false,
            likeCount: carModel.analytics?.likes ?? 0,
          ),
          IgnorePointer(
            ignoring: isDelete,
            child: ShareButtonWithIcon(
              isSliderOption: false,
              onTapShare: () {
                final make =
                    carModel.manufacturer?.name?.toUpperCase() ?? shortAppName;
                final model = carModel.model ?? appName;
                shareFeature(
                  content: make +
                      nextLine +
                      model +
                      nextLine +
                      generateDeepLink('carId=${carModel.carId ?? ''}'),
                  imgUrl: carModel.image ?? '',
                );
              },
            ),
          ),
          IgnorePointer(
            ignoring: isDelete,
            child: ChatWithIcon(
              isSliderOption: false,
              onTapChatNow: () async => createChatGroup(
                car: carModel,
                selectedIndex: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget carDetails(LikedCarModel carModel) {
    return Padding(
      padding: getPadding(
        left: 19.w,
        right: 19.w,
        bottom: 24.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      carModel.manufacturer?.name?.toUpperCase() ??
                          notApplicable,
                      style: AppTextStyle.labelTextStyle,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      carModel.model?.toUpperCase() ?? notApplicable,
                      maxLines: 2,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.kColor353333,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: getPadding(left: 5.w),
                child: Text(
                  euro + currencyFormatter(carModel.userExpectedValue ?? 0),
                  style: AppTextStyle.regularTextStyle.copyWith(
                    fontSize: getFontSize(20),
                    color: ColorConstant.kColor353333,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (carModel.additionalInformation?.attentionGraber != null &&
              carModel.additionalInformation!.attentionGraber!.isNotEmpty)
            SizedBox(height: 10.h),
          if (carModel.additionalInformation?.attentionGraber != null &&
              carModel.additionalInformation!.attentionGraber!.isNotEmpty)
            Text(
              carModel.additionalInformation?.attentionGraber ?? notApplicable,
              style: AppTextStyle.txtPTSansBold12Gray600
                  .copyWith(fontSize: getFontSize(14)),
            ),
          SizedBox(height: 10.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: getPadding(
                    left: 8,
                    top: 5,
                    right: 8,
                    bottom: 5,
                  ),
                  decoration:
                      AppDecoration.gradientDeeporangeA200Yellow900.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder5,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: (carModel.fuelType?.name?.toUpperCase() ?? '') +
                              mileageOfVehicle,
                          style: AppTextStyle.smallTextStyle.copyWith(
                            color: ColorConstant.kColorWhite,
                          ),
                        ),
                        TextSpan(
                          text: '${currencyFormatter(carModel.mileage ?? 0)}'
                              ' ${milesLabel.toUpperCase()}',
                          style: AppTextStyle.smallTextStyle.copyWith(
                            color: ColorConstant.kColorWhite,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (carModel.additionalInformation?.attentionGraber != null &&
                  carModel.additionalInformation!.attentionGraber!.isNotEmpty)
                SizedBox(width: 10.w),
              if (carModel.additionalInformation?.attentionGraber != null &&
                  carModel.additionalInformation!.attentionGraber!.isNotEmpty)
                Expanded(
                  child: CustomElevatedButton(
                    customBorderRadius: BorderRadiusStyle.roundedBorder5,
                    fontSize: getFontSize(12),
                    height: 24.h,
                    title: moreButton,
                    onTap: () {
                      customPopup(
                          content: DescriptionPopupWidget(
                        car: CarModel(
                            additionalInformation:
                                carModel.additionalInformation),
                      ));
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void createChatGroup({
    required LikedCarModel car,
    required int selectedIndex,
  }) {
    String? userId;
    String? username;
    String? userImage;
    String? userType;
    num? rating;
    if (currentUserData?.userType == convertEnumToString(UserType.private)) {
      userId = currentUserData?.userId;
      username = currentUserData?.userName;
      userImage = currentUserData?.avatarImage;
      userType = currentUserData?.userType;
    } else {
      userId = currentUserData?.userId;
      username = currentUserData?.trader?.companyName;
      userImage = currentUserData?.trader?.logo;
      rating = currentUserData?.trader?.companyRating;
      userType = convertEnumToString(UserType.dealerAdmin);
      if (currentUserData?.userType ==
          convertEnumToString(UserType.dealerSubUser)) {
        userId = currentUserData?.trader?.adminUserId;
      }
    }
    userOrTraderId = userId ?? '';

    final String groupId = generateHash(
      car.ownerId!,
      userId!,
      car.carId!,
    );

    final chatGroup = ChatGroupModel()
      ..groupId = groupId
      ..groupAdminUserId = userId
      ..groupNameForSearch = (car.manufacturer?.name ?? '').toLowerCase()
      ..lastMessage = ''
      ..isChatAvailable = false
      ..groupUsers = [userId, car.ownerId!]
      ..createdAt = getCurrentDateTime()
      ..updatedAt = getCurrentDateTime()
      ..carDetails = ChatCarModel(
          carId: car.carId,
          carName: car.manufacturer?.name,
          carModelName: car.model,
          carCash: car.userExpectedValue,
          carImage: car.image,
          userId: car.ownerId)
      ..receiver = ChatUserModel(
          userId: car.ownerId,
          userName: car.userName,
          userImage: car.avatarImage,
          userType: car.userType,
          rating: car.rating)
      ..admin = ChatUserModel(
          userId: userId,
          userImage: userImage,
          userName: username,
          userType: userType,
          rating: rating);
    context.read<ChatBloc>().add(CreateChatGroupEvent(
          chatGroup: chatGroup,
          routeName: CarProfileScreen.routeName,
          selectedIndex: selectedIndex,
        ));
  }

  //loader
  void setLoader(bool isLoader) {
    if (isLoader) {
      progressDialogue();
    } else {
      Navigator.pop(context);
    }
  }

//filter bottom sheet
  Future<void> callFilterBottomSheet() async {
    final response = await filterLikedCarBottomSheet(selectedFilter)
        as Map<String, dynamic>?;
    if (response != null) {
      if (response.isNotEmpty) {
        selectedFilter = response;
        filterJsonData = getFilteredData(response);
      } else {
        filterJsonData = selectedFilter = response;
      }
      fetchLikedCar();
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
      json[key.makers] = [temp.join(',')];
    }
    if (response.containsKey(key.model)) {
      List<String> temp = [];
      for (final BrandModel item in response[key.model] as List<BrandModel>) {
        temp.add(item.name ?? '');
      }
      json[key.model] = [temp.join(',')];
    }
    if (response.containsKey(key.bodyType)) {
      List<String> temp = [];
      for (final ValuesSectionInput item
          in response[key.bodyType] as List<ValuesSectionInput>) {
        temp.add(item.id ?? '');
      }
      json[key.bodyType] = [temp.join(',')];
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
      json[key.transmissionType] = [temp.join(',')];
    }
    if (response.containsKey(key.fuelType)) {
      List<String> temp = [];
      for (final ValuesSectionInput item
          in response[key.fuelType] as List<ValuesSectionInput>) {
        temp.add(item.id ?? '');
      }
      json[key.fuelType] = [temp.join(',')];
    }
    if (response.containsKey(key.userType)) {
      json[key.userType] = response[key.userType];
    }
    return json;
  }
}
