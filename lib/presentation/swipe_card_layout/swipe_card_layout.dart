import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:lottie/lottie.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/view_cars/view_cars_bloc.dart';
import '../../core/configurations.dart';
import '../../core/locator.dart';
import '../../main.dart';
import '../../model/car_model/car_model.dart';
import '../../model/car_model/value_section_input.dart';
import '../../model/chat_model/chat_group/chat_car_model.dart';
import '../../model/chat_model/chat_group/chat_group_model.dart';
import '../../model/chat_model/chat_group/chat_user_model.dart';
import '../../model/technical_details/manufacturer.dart';
import '../../model/user/user_model.dart';
import '../../repository/car_repo.dart';
import '../../service/shared_preference_service.dart';
import '../../utility/chat_utils.dart';
import '../../utility/common_keys.dart' as key;
import '../../utility/date_time_utils.dart';
import '../../utility/routes_from_bottom.dart';
import '../chat_screen/screens/user_chat_window.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../error_screen/error_widget.dart';
import '../notification/notification_screen.dart';
import '../user_type_selection/user_types_selection.dart';
import '../view_match_car/car_profile.dart';
import 'filter_bottomsheet/filter_view_match_bottomsheet.dart';
import 'widgets/car_info_card.dart';
import 'widgets/car_info_card_shimmer.dart';
import 'widgets/help_info_mark.dart';

class SwipeCardLayout extends StatefulWidget {
  static const String routeName = 'swipe_card_screen';
  const SwipeCardLayout({
    Key? key,
    this.isGuest = false,
    this.drawerOnTap,
    this.floatingActionButton,
    this.bottomNavigationBar,
  }) : super(key: key);
  final VoidCallback? drawerOnTap;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool isGuest;
  @override
  State<SwipeCardLayout> createState() => _SwipeCardLayoutState();
}

class _SwipeCardLayoutState extends State<SwipeCardLayout> {
  List<CarModel> _swipeItems = <CarModel>[];
  final AppinioSwiperController swiperController = AppinioSwiperController();
  bool likeVisibility = false;
  bool dislikeVisibility = false;

  int pageNo = 0;
  String paginationKey = '';
  Map<String, dynamic> listingParaMeter = {};
  //to remove already viewed cars put TRUE
  bool filterRecentCars = true;
  bool ignoreTouch = false;

  UserModel? currentUser;
  String userIdOrAdminUserId = '';

  //Key
  GlobalKey swipeKey = GlobalKey();
  List<GlobalKey> makeAnOfferKey = [];
  List<GlobalKey> premiumKey = [];
  List<GlobalKey> quickSaleTutorialKey = [];
  List<GlobalKey> backButtonKey = [];
  List<GlobalKey> filterButtonKey = [];
  List<GlobalKey> viewDetailsButtonKey = [];

  //Help Screen Info
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];
  ValueNotifier<bool> isTutorialVisible = ValueNotifier<bool>(false);

  //Redo Function
  int count = 0;
  ValueNotifier<bool> redoEnable = ValueNotifier<bool>(true);

  //Filter json
  Map<String, dynamic> filterJsonData = {};
  Map<String, dynamic> selectedFilter = {};

  //refresh ui
  final ValueNotifier<bool> _refresh = ValueNotifier<bool>(false);
  late String userOrTraderId;

  Future<void> getRedoActionCounts() async {
    if (count == 4) {
      infoOrThankyouPopup(
        title: redoSwipePopupTitle,
        message: redoSwipePopupMessage,
      );
      redoEnable = ValueNotifier<bool>(false);
    } else {
      ++count;
    }
  }

  Future<void> _showTutorial() async {
    isTutorialVisible = ValueNotifier<bool>(true);
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      onSkip: () {
        setState(() => ignoreTouch = false);
        Locator.instance.get<SharedPrefServices>().setHelpInfo(false);
      },
      hideSkip: true,
    );
    tutorialCoachMark!.show(context: context);
    setState(() {});
  }

  //key Generate
  void _generateKey(int length) {
    makeAnOfferKey = keyList(length);
    premiumKey = keyList(length);
    quickSaleTutorialKey = keyList(length);
    backButtonKey = keyList(length);
    filterButtonKey = keyList(length);
    viewDetailsButtonKey = keyList(length);
  }

  List<GlobalKey<State<StatefulWidget>>> keyList(int length) =>
      List<GlobalKey>.generate(
        length,
        (index) => GlobalKey(debugLabel: 'key_$index'),
        growable: false,
      );

  //Assigning the key of target
  void _initTarget(int index) {
    targets = [
      TargetFocus(
        identify: "first-item-key",
        keyTarget: swipeKey,
        enableTargetTab: false,
        focusAnimationDuration: const Duration(milliseconds: 10),
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
              top: MediaQuery.of(context).size.height / 2.5,
              left: 10.w,
              right: 10.w,
            ),
            builder: (context, controller) {
              return CoachMarkDesc(
                isFirstPage: true,
                onTapDismiss: () => controller.next(),
                onTapNext: () => controller.next(),
                currentIndex: 6,
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "quick-sale-key",
        keyTarget: quickSaleTutorialKey[index],
        enableTargetTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
                top: MediaQuery.of(context).size.height / 2.5),
            builder: (context, controller) {
              return CoachMarkDesc(
                titleText: quickSaleBadgingInfo,
                descText: tutorialDescription,
                onTapDismiss: () => onTapDismiss(controller),
                onTapNext: () => controller.next(),
                currentIndex: 0,
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "premium-key",
        keyTarget: premiumKey[index],
        enableTargetTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
                top: MediaQuery.of(context).size.height / 2.5),
            builder: (context, controller) {
              return CoachMarkDesc(
                titleText: premiumPostBadgingInfo,
                descText: tutorialDescription,
                onTapDismiss: () => onTapDismiss(controller),
                onTapNext: () => controller.next(),
                currentIndex: 1,
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "view-details-key",
        keyTarget: viewDetailsButtonKey[index],
        enableTargetTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
                top: MediaQuery.of(context).size.height / 3.3),
            builder: (context, controller) {
              return CoachMarkDesc(
                titleText: viewDetailsButtonInfo,
                descText: tutorialDescription,
                onTapDismiss: () => onTapDismiss(controller),
                onTapNext: () => controller.next(),
                currentIndex: 2,
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "back-button-key",
        keyTarget: backButtonKey[index],
        enableTargetTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
                top: MediaQuery.of(context).size.height / 2.5),
            builder: (context, controller) {
              return CoachMarkDesc(
                titleText: backButtonInfo,
                descText: sampleTextTutorial,
                onTapDismiss: () => onTapDismiss(controller),
                onTapNext: () => controller.next(),
                currentIndex: 3,
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "make-an-offer-key",
        keyTarget: makeAnOfferKey[index],
        enableTargetTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
                top: MediaQuery.of(context).size.height / 2.5),
            builder: (context, controller) {
              return CoachMarkDesc(
                titleText: makeAnOfferButtonInfo,
                descText: tutorialDescription,
                onTapDismiss: () => onTapDismiss(controller),
                onTapNext: () => controller.next(),
                currentIndex: 4,
              );
            },
          )
        ],
      ),
      TargetFocus(
        identify: "filter-button-key",
        keyTarget: filterButtonKey[index],
        enableTargetTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(
                top: MediaQuery.of(context).size.height / 2.5),
            builder: (context, controller) {
              return CoachMarkDesc(
                titleText: filterButtonInfo,
                descText: sampleTextTutorial,
                isLastPage: true,
                onTapDismiss: () => onTapDismiss(controller),
                onTapNext: () => controller.next(),
                currentIndex: 5,
              );
            },
          )
        ],
      ),
    ];
  }

  void onTapDismiss(TutorialCoachMarkController controller) {
    isTutorialVisible = ValueNotifier<bool>(false);
    controller.skip();
    setState(() {});
  }

  @override
  void initState() {
    currentUser = context.read<UserBloc>().currentUser;
    if (!widget.isGuest) {
      userOrTraderId =
          currentUser!.userType == convertEnumToString(UserType.private)
              ? currentUser!.userId!
              : currentUser!.traderId!;
    }
    if (Locator.instance.get<SharedPrefServices>().getHelpInfo()) {
      setState(() => ignoreTouch = true);
    }
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    swiperController.dispose();
    super.dispose();
  }

  Future<void> loadData({bool isLoadMore = false}) async => isLoadMore
      ? await getMoreCars(filterJson: listingParaMeter)
      : await getCars(filterJson: listingParaMeter);

  Future<void> getCars({
    Map<String, dynamic>? filterJson,
  }) async {
    pageNo = 0;
    paginationKey = '';
    final Map<String, dynamic> listingParameterJson = widget.isGuest
        ? {
            'listingParams': {
              'pageNo': pageNo,
              'paginationKey': paginationKey,
            }
          }
        : {
            'pageNo': pageNo,
            'paginationKey': paginationKey,
            'filters': filterJson,
            'filterRecentCars': filterRecentCars,
          };
    BlocProvider.of<ViewCarsBloc>(context).add(
      GetCarsEvent(
        isGuest: widget.isGuest,
        listingParams: listingParameterJson,
      ),
    );
  }

  Future<void> getMoreCars({
    Map<String, dynamic>? filterJson,
  }) async {
    final Map<String, dynamic> listingParameterJson = widget.isGuest
        ? {
            'listingParams': {
              'pageNo': ++pageNo,
              'paginationKey': paginationKey,
            }
          }
        : {
            'pageNo': ++pageNo,
            'paginationKey': paginationKey,
            'filters': filterJson,
            'filterRecentCars': filterRecentCars,
          };
    BlocProvider.of<ViewCarsBloc>(context).add(
      GetMoreCarsEvent(
        isGuest: widget.isGuest,
        listingParams: listingParameterJson,
      ),
    );
  }

  void setLoading(bool value) {
    if (value) {
      progressDialogue();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> onTapBack({
    required CarModel carModel,
    required int index,
  }) async {
    if (widget.isGuest) {
      guestNavigation();
    } else {
      if (index != 0) {
        getRedoActionCounts();
        swiperController.unswipe();
        final Map<String, dynamic> unlikeACarJson = {
          'carId': carModel.id,
          'userId': userOrTraderId,
          'deleteAll': false,
        };
        await Locator.instance
            .get<CarRepo>()
            .unlikeACarRepo(carInfoJson: unlikeACarJson);
      }
    }
  }

  Future<void> onSwipeCard({
    int index = 0,
    required AppinioSwiperDirection direction,
  }) async {
    if (index > 0 && index.remainder(20) == 0 && widget.isGuest) {
      bool result = await confirmationPopup(
        title: exploreMoreTitle,
        message: toEnjoyAppPleaseCreateAccount,
        successBtnText: signUpButton,
        closeBtnText: dismissButton,
      );
      if (result) {
        Navigator.pushNamedAndRemoveUntil(
          globalNavigatorKey.currentContext!,
          SelectUserTypesScreen.routeName,
          (route) => false,
        );
      }
    }
    if (direction == AppinioSwiperDirection.right) {
      likeVisibility = true;
      dislikeVisibility = false;
      delayedStart(() {
        if (mounted) {
          likeVisibility = false;
          _refresh.value = !_refresh.value;
        }
      }, duration: const Duration(milliseconds: 800));
      final Map<String, dynamic> likeInfoJson = {
        'carId': _swipeItems[index].id,
        'ownerId': _swipeItems[index].userId,
        'ownerType': _swipeItems[index].userType,
      };
      Locator.instance.get<CarRepo>().likeCarRepo(likeInfoJson: likeInfoJson);
      _refresh.value = !_refresh.value;
    } else {
      dislikeVisibility = true;
      likeVisibility = false;
      delayedStart(() {
        if (mounted) {
          dislikeVisibility = false;
          _refresh.value = !_refresh.value;
        }
      }, duration: const Duration(milliseconds: 800));
      Locator.instance
          .get<CarRepo>()
          .dislikeCarRepo(carId: _swipeItems[index].id ?? '');
      _refresh.value = !_refresh.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatGroupCreateState &&
            state.routeName == SwipeCardLayout.routeName) {
          if (state.createChatGroupStatus == ProviderStatus.success) {
            setLoading(false);
            Navigator.pushNamed(
              context,
              UserChatScreen.routeName,
              arguments: {
                'chatGroup': state.chatGroup,
                'userIdOrAdminUserId': userIdOrAdminUserId,
                'selectedIndex': 1,
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
        title: homeNavAppBar,
        drawerOnTap: ignoreTouch ? null : widget.drawerOnTap,
        actions: [
          CustomImageView(
            svgPath: Assets.notificationIcon,
            onTap: () {
              if (widget.isGuest) {
                guestNavigation();
              } else {
                Navigator.pushNamed(context, NotificationScreen.routeName);
              }
            },
          ),
          CustomImageView(
            svgPath: Assets.help,
            margin: getMargin(left: 18.w, right: 20.w),
            onTap: () => _swipeItems.isNotEmpty ? _showTutorial() : null,
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
            BlocConsumer<ViewCarsBloc, ViewCarsState>(
              listener: (context, state) async {
                if (state is GetCarsState &&
                    state.getCarsStatus == ProviderStatus.success) {
                  _swipeItems =
                      List.from(state.getCarsResponseModel?.cars ?? []);
                  if (_swipeItems.isNotEmpty) {
                    paginationKey =
                        state.getCarsResponseModel?.paginationKey ?? '';

                    _generateKey(_swipeItems.length);

                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (Locator.instance
                          .get<SharedPrefServices>()
                          .getHelpInfo()) {
                        _showTutorial();
                      }
                    });
                  }
                } else if (state is GetMoreCarsState &&
                    state.getMoreCarsStatus == ProviderStatus.success) {
                  _swipeItems =
                      List.from(state.getMoreCarsResponseModel?.cars ?? []);
                  if (_swipeItems.isNotEmpty) {
                    _generateKey(_swipeItems.length);

                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (Locator.instance
                          .get<SharedPrefServices>()
                          .getHelpInfo()) {
                        _showTutorial();
                      }
                    });
                  }
                }
              },
              builder: (context, state) {
                if (state is GetCarsState) {
                  if (state.getCarsStatus == ProviderStatus.success) {
                    return swipeCarCards(_swipeItems);
                  } else if (state.getCarsStatus == ProviderStatus.error) {
                    return errorWidget();
                  }
                } else if (state is GetMoreCarsState) {
                  if (state.getMoreCarsStatus == ProviderStatus.success) {
                    if ((state.getMoreCarsResponseModel?.cars ?? [])
                        .isNotEmpty) {
                      paginationKey =
                          state.getMoreCarsResponseModel?.paginationKey ?? '';
                    }

                    return swipeCarCards(_swipeItems);
                  } else if (state.getMoreCarsStatus == ProviderStatus.error) {
                    return errorWidget(isLoadMore: true);
                  }
                }
                return const CarInfoCardShimmer();
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(key: swipeKey),
            ),
          ],
        ),
        floatingActionButton: widget.floatingActionButton,
        bottomNavigationBar: widget.bottomNavigationBar,
      ),
    );
  }

  Widget swipeCarCards(List<CarModel> cars) {
    return cars.isNotEmpty
        ? AppinioSwiper(
            padding: getPadding(all: 0),
            threshold: 100,
            controller: swiperController,
            swipeOptions: const AppinioSwipeOptions.symmetric(horizontal: true),
            unlimitedUnswipe: true,
            cardsCount: cars.length,
            cardsBuilder: (BuildContext context, int index) {
              //To pass the current car Info key
              _initTarget(index);
              final CarModel carModelItem = cars[index];
              return Stack(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: isTutorialVisible,
                    builder: (context, val, child) {
                      return CarInfoCard(
                        redoEnable: redoEnable,
                        isTutorialVisible: val,
                        car: carModelItem,
                        premiumTutorialKey: premiumKey[index],
                        backButtonTutorialKey: backButtonKey[index],
                        quickSaleTutorialKey: quickSaleTutorialKey[index],
                        filterButtonTutorialKey: filterButtonKey[index],
                        makeAnOfferTutorialKey: makeAnOfferKey[index],
                        viewDetailsButtonTutorialKey:
                            viewDetailsButtonKey[index],

                        ///UNDO
                        onTapBack: () async => onTapBack(
                          carModel: carModelItem,
                          index: index,
                        ),

                        ///FILTER
                        onTapFilter: () {
                          if (widget.isGuest) {
                            guestNavigation();
                          } else {
                            callFilterBottomSheet();
                          }
                        },

                        ///MAKE AN OFFER
                        onTapMakeOffer: () async {
                          if (widget.isGuest) {
                            guestNavigation();
                          } else {
                            createChatGroup(carModelItem);
                          }
                        },

                        ///On View Details
                        onTapViewDetails: () {
                          if (widget.isGuest) {
                            guestNavigation();
                          } else {
                            Navigator.pushNamed(
                              context,
                              CarProfileScreen.routeName,
                              arguments: {'carModel': carModelItem},
                            );
                          }
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                      valueListenable: _refresh,
                      builder: (context, bool isRefresh, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: likeVisibility,
                              child: Align(
                                child: SizedBox(
                                  width: getSize(200),
                                  height: getSize(200),
                                  child: Lottie.asset(Assets.likeJson),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: dislikeVisibility,
                              child: Align(
                                child: SizedBox(
                                  width: getSize(200),
                                  height: getSize(200),
                                  child: Lottie.asset(Assets.dislikeJson),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ],
              );
            },
            onSwipe: (index, direction) async => onSwipeCard(
              index: index - 1,
              direction: direction,
            ),
            onEnd: () {
              if (cars.isNotEmpty) {
                loadData(isLoadMore: true);
              }
            },
          )
        : emptySwipeCard();
  }

  Widget emptySwipeCard() {
    return Container(
      alignment: Alignment.center,
      height: getVerticalSize(size.height),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomImageView(svgPath: Assets.emptySwipeCard),
          Padding(
            padding: getPadding(top: 25.h, bottom: 39.h),
            child: Text(
              pleaseBroadenYourSearch,
              style: AppTextStyle.regularTextStyle.copyWith(
                fontSize: getFontSize(16),
                color: ColorConstant.kColor606060,
              ),
            ),
          ),
          CustomElevatedButton(
            title: modifyButton,
            width: getHorizontalSize(size.width / 2),
            onTap: () {
              if (widget.isGuest) {
                guestNavigation();
              } else {
                callFilterBottomSheet();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget errorWidget({bool isLoadMore = false}) {
    return Container(
      alignment: Alignment.topCenter,
      margin: getMargin(top: size.height * 0.15),
      height: size.height,
      child: ErrorWithButtonWidget(
        message: errorOccurred,
        buttonLabel: retryButton,
        onTap: () => loadData(isLoadMore: isLoadMore),
      ),
    );
  }

  //filter bottom sheet
  Future<void> callFilterBottomSheet() async {
    final result = await Navigator.of(context).push(
      RouteAnimation.createRoute(
        FilterBottomSheetWidget(filterData: filterJsonData),
      ),
    );
    final response = result as Map<String, dynamic>;
    if (response.isNotEmpty) {
      selectedFilter = response;
      filterJsonData = getFilteredData(response);
    } else {
      filterJsonData = selectedFilter = response;
    }
    await getCars(filterJson: filterJsonData);
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

  void createChatGroup(CarModel car) {
    String? userId;
    String? username;
    String? userImage;
    String? userType;
    num? rating;
    if (currentUser?.userType == convertEnumToString(UserType.private)) {
      userId = currentUser?.userId;
      username = currentUser?.userName;
      userImage = currentUser?.avatarImage;
      userType = currentUser?.userType;
    } else {
      userId = currentUser?.userId;
      username = currentUser?.trader?.companyName;
      userImage = currentUser?.trader?.logo;
      userType = convertEnumToString(UserType.dealerAdmin);
      rating = currentUser?.trader?.companyRating;
      if (currentUser?.userType ==
          convertEnumToString(UserType.dealerSubUser)) {
        userId = currentUser?.trader?.adminUserId;
      }
    }
    userIdOrAdminUserId = userId ?? '';

    //current car userId,currentUserId,carId
    final String groupId = generateHash(
      car.userId!,
      userId!,
      car.id!,
    );

    final chatGroup = ChatGroupModel()
      ..groupId = groupId
      ..groupAdminUserId = userId
      ..groupNameForSearch = (car.manufacturer?.name ?? '').toLowerCase()
      ..lastMessage = ''
      ..isChatAvailable = false
      ..groupUsers = [userId, car.userId!]
      ..createdAt = getCurrentDateTime()
      ..updatedAt = getCurrentDateTime()
      ..carDetails = ChatCarModel(
          carId: car.id,
          carName: car.manufacturer?.name,
          carModelName: car.model,
          carCash: car.userExpectedValue,
          carImage: car.uploadPhotos?.rightImages != null
              ? car.uploadPhotos?.rightImages![0]
              : null,
          userId: car.userId)
      ..receiver = ChatUserModel(
          userId: car.userId,
          userName: car.ownerUserName,
          userImage: car.ownerProfileImage,
          userType: car.userType,
          rating: car.userRating)
      ..admin = ChatUserModel(
          userId: userId,
          userImage: userImage,
          userName: username,
          userType: userType,
          rating: rating);
    context.read<ChatBloc>().add(CreateChatGroupEvent(
          chatGroup: chatGroup,
          routeName: SwipeCardLayout.routeName,
        ));
  }
}
