import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wsac/bloc/other_cars_by_user/other_cars_bloc.dart';

import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../core/configurations.dart';
import '../../model/car_model/car_model.dart';
import '../../model/chat_model/chat_group/chat_car_model.dart';
import '../../model/chat_model/chat_group/chat_group_model.dart';
import '../../model/chat_model/chat_group/chat_user_model.dart';
import '../../model/user/user_model.dart';
import '../../utility/chat_utils.dart';
import '../../utility/date_time_utils.dart';
import '../chat_screen/screens/user_chat_window.dart';
import '../common_popup_widget/decription_popup.dart';
import '../common_widgets/common_admin_support_button.dart';
import '../common_widgets/common_divider.dart';
import '../common_widgets/common_loader.dart';
import '../common_widgets/common_popups.dart';
import '../common_widgets/custom_text_widget.dart';
import '../need_finance/need_finance_screen.dart';
import '../report_an_issue/report_an_issue_screen.dart';
import 'view_profile.dart';
import 'widgets/car_profile_slider.dart';
import 'widgets/related_car_item.dart';

class CarProfileScreen extends StatefulWidget {
  static const String routeName = 'car_profile_screen';
  const CarProfileScreen({Key? key, this.carModel}) : super(key: key);
  final CarModel? carModel;
  @override
  State<CarProfileScreen> createState() => _CarProfileScreenState();
}

class _CarProfileScreenState extends State<CarProfileScreen> {
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  UserModel? currentUser;
  String userIdOrAdminUserId = '';
  bool isLoading = false;
  int perPage = 10;
  int pageNo = 0;
  List<CarModel> otherCars = [];

  @override
  void initState() {
    super.initState();
    currentUser = context.read<UserBloc>().currentUser;
    fetchOtherCarsByUser();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  ///Other cars by same user
  Future<void> fetchOtherCarsByUser() async {
    pageNo = 0;
    final variables = {
      'pageNo': pageNo,
      'perPage': perPage,
      'exclude': widget.carModel?.id ?? '',
      'userId': currentUser?.userId ?? '',
    };
    context
        .read<OtherCarsBloc>()
        .add(GetOtherCarsEvent(fetchOtherCarjson: variables));
  }

  ///Other more cars by same user
  Future<void> fetchMoreOtherCarsByUser() async {
    final variables = {
      'pageNo': ++pageNo,
      'perPage': perPage,
      'exclude': widget.carModel?.id ?? '',
      'userId': currentUser?.userId ?? '',
    };
    context
        .read<OtherCarsBloc>()
        .add(GetMoreOtherCarsEvent(fetchMoreOtherCarjson: variables));
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
                'userIdOrAdminUserId': userIdOrAdminUserId,
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
      child: CustomScaffold(
        title: carProfileAppBar,
        actions: const [
          AdminSupportButton(),
        ],
        body: Stack(
          children: [
            CustomImageView(
              svgPath: Assets.homeBackground,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              fit: BoxFit.fill,
            ),
            bodyWidget(widget.carModel!),
          ],
        ),
      ),
    );
  }

  Widget shimmerEffect() {
    return Padding(
      padding: getPadding(left: 25.w, right: 25.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerLoader(
              Container(
                margin: getMargin(bottom: 18.h),
                height: getVerticalSize(59.h),
                decoration: AppDecoration.outlineBlack9000c.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder39,
                ),
              ),
            ),
            shimmerLoader(
              Container(
                height: getVerticalSize(300.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConstant.kColorWhite,
                  borderRadius: BorderRadius.circular(21.r),
                ),
              ),
            ),
            Padding(
              padding: getPadding(top: 16.h, bottom: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  shimmerLoader(
                    Container(
                      height: getVerticalSize(20.h),
                      width: getHorizontalSize(100.w),
                      margin: getMargin(bottom: 5.h),
                      decoration: BoxDecoration(
                        color: ColorConstant.kColorWhite,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                  ),
                  shimmerLoader(
                    Container(
                      height: getVerticalSize(20.h),
                      width: getHorizontalSize(150.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.kColorWhite,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const GradientDivider(),
            shimmerLoader(
              Container(
                height: getVerticalSize(20.h),
                width: getHorizontalSize(150.w),
                margin: getMargin(top: 10.h),
                decoration: BoxDecoration(
                  color: ColorConstant.kColorWhite,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: getPadding(
                bottom: 20.h,
                top: 20.h,
              ),
              child: Wrap(
                spacing: 12.w,
                children: [
                  for (int i = 0; i <= 5; i++)
                    shimmerLoader(
                      Container(
                        height: getVerticalSize(150.h),
                        width: getHorizontalSize(size.width / 1.7),
                        decoration: BoxDecoration(
                          color: ColorConstant.kColorWhite,
                          borderRadius: BorderRadius.circular(21.r),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyWidget(CarModel car) {
    return Column(
      children: [
        Expanded(
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: getPadding(left: 20.w, right: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userInfoCard(car),
                        carDetailsBox(car),
                        Padding(
                          padding: getPadding(top: 21.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  ReportAnIssueScreen.routeName,
                                  arguments: {'car': car},
                                ),
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      svgPath: Assets.reportUser,
                                      margin: getMargin(right: 8.w),
                                    ),
                                    Text(
                                      reportThisUser,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppTextStyle.txtPTSansBold12,
                                    ),
                                  ],
                                ),
                              ),
                              if (currentUser?.userType ==
                                  convertEnumToString(UserType.private))
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, NeedFinanceScreen.routeName),
                                  child: Row(
                                    children: [
                                      CustomImageView(
                                        svgPath: Assets.needFinance,
                                        margin: getMargin(right: 8.w),
                                      ),
                                      Text(
                                        needFinanace,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppTextStyle.txtPTSansBold12,
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: getPadding(top: 17.h, bottom: 17.h),
                          child: const GradientDivider(),
                        ),
                        Padding(
                          padding: getPadding(bottom: 18),
                          child: Text(
                            otherCarCurrentlyListedBy.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppTextStyle.txtPTSansBold12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocConsumer<OtherCarsBloc, OtherCarsState>(
                    listener: (context, state) {
                      if (state is GetMoreOtherCarsState &&
                          state.moreOtherCarsStatus == ProviderStatus.success) {
                        if (state.moreotherCars!.isNotEmpty) {
                          otherCars.addAll(state.moreotherCars!);
                          _easyRefreshController.finishLoad(
                              IndicatorResult.success, true);
                        } else {
                          _easyRefreshController.finishLoad(
                              IndicatorResult.noMore, true);
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is GetOtherCarsState) {
                        if (state.otherCarsStatus == ProviderStatus.success) {
                          otherCars = List.from(state.otherCars ?? []);
                          return otherCarsList();
                        } else if (state.otherCarsStatus ==
                            ProviderStatus.error) {
                          return CustomElevatedButton(
                            title: retryButton,
                            onTap: () async => await fetchOtherCarsByUser(),
                          );
                        }
                      } else if (state is GetMoreOtherCarsState) {
                        return otherCarsList();
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: getPadding(
                          bottom: 20.h,
                          left: 20.w,
                          right: 20.w,
                        ),
                        child: Wrap(
                          spacing: 12.w,
                          children: [
                            for (int i = 0; i <= 5; i++)
                              shimmerLoader(
                                Container(
                                  height: getVerticalSize(150.h),
                                  width: getHorizontalSize(size.width / 1.7),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.kColorWhite,
                                    borderRadius: BorderRadius.circular(21.r),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: getPadding(
              left: 20.w,
              top: 10.h,
              right: 20.w,
              bottom: 12.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    title: chatButton,
                    onTap: () => createChatGroup(
                      car: widget.carModel!,
                      selectedIndex: 0, //chat
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: GradientElevatedButton(
                    title: makeAnOfferButton,
                    onTap: () => createChatGroup(
                      car: widget.carModel!,
                      selectedIndex: 1, //make an offer
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget userInfoCard(CarModel car) {
    return Container(
      padding: getPadding(
        left: 12.w,
        right: 15.w,
        top: 10.h,
        bottom: 10.h,
      ),
      decoration: AppDecoration.outlineBlack9000c.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder39,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  height: getSize(42),
                  width: getSize(42),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    gradient: LinearGradient(colors: kPrimaryGradientColor),
                  ),
                  child: (car.ownerProfileImage != null &&
                              car.ownerProfileImage!.isNotEmpty) ||
                          (car.companyLogo != null &&
                              car.companyLogo!.isNotEmpty)
                      ? CustomImageView(
                          url: car.userType == UserType.private.name
                              ? car.ownerProfileImage
                              : car.companyLogo,
                          height: getSize(42),
                          width: getSize(42),
                          radius: BorderRadius.circular(100.r),
                          fit: BoxFit.cover,
                        )
                      : CustomImageView(
                          svgPath: car.userType == UserType.private.name
                              ? Assets.privatePlaceholder
                              : Assets.dealerPlaceholder,
                          color: ColorConstant.kColorWhite,
                          margin: getMargin(all: 9),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    car.userType == UserType.private.name
                        ? car.ownerUserName ?? shortAppName
                        : car.companyName ?? shortAppName,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppTextStyle.txtPTSansBold15Red300,
                  ),
                ),
              ],
            ),
          ),
          if (car.userType != UserType.private.name)
            RatingBar.builder(
              initialRating: car.companyRating?.toDouble() ?? 0.0,
              minRating: 1,
              allowHalfRating: true,
              itemSize: 15,
              itemPadding: getPadding(left: 3.w, right: 3.w),
              unratedColor: Colors.grey,
              ignoreGestures: true,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (double value) {},
            ),
        ],
      ),
    );
  }

  Widget otherCarsList() {
    return otherCars.isNotEmpty
        ? SizedBox(
            height: 181.h,
            child: EasyRefresh(
              triggerAxis: Axis.horizontal,
              controller: _easyRefreshController,
              footer: const ClassicFooter(
                showText: false,
                failedIcon: SizedBox(),
                noMoreIcon: Text(
                  "No more cars",
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
              onLoad: () => fetchMoreOtherCarsByUser(),
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: otherCars.length,
                padding: const EdgeInsets.only(left: 10),
                itemBuilder: (_, int i) {
                  return RelatedCarItem(car: otherCars[i]);
                },
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
              ),
            ),
          )
        : const CenterText(text: 'No car available');
  }

  Widget carDetailsBox(CarModel car) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        ViewProfileScreen.routeName,
        arguments: {'carId': car.id},
      ),
      child: Container(
        width: getHorizontalSize(size.width),
        margin: getMargin(top: 19.h),
        decoration: AppDecoration.outlineBlack90021.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(21.r),
                topRight: Radius.circular(21.r),
              ),
              child: CarProfileContentSlider(
                car: car,
                aspectRatio: 2,
                parentWidgetSize: (MediaQuery.of(context).size.width - 45.w),
                onTap: () => Navigator.pushNamed(
                  context,
                  ViewProfileScreen.routeName,
                  arguments: {'carId': car.id},
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: getPadding(left: 20.w, top: 10.h, right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.manufacturer?.name?.toUpperCase() ??
                                  notApplicable,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppTextStyle.txtPTSansRegular12Red300,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              car.model?.toUpperCase() ?? notApplicable,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style: AppTextStyle.txtPTSansBold14Bluegray900,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        euro +
                            currencyFormatter(car.userExpectedValue!.toInt()),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppTextStyle.regularTextStyle.copyWith(
                          color: ColorConstant.kColorBlack,
                          fontSize: getFontSize(20),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (car.additionalInformation?.attentionGraber != null &&
                    car.additionalInformation!.attentionGraber!.isNotEmpty)
                  Padding(
                    padding: getPadding(top: 6, left: 20, right: 20, bottom: 5),
                    child: Text(
                      car.additionalInformation?.attentionGraber ??
                          notApplicable,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.regularTextStyle.copyWith(
                        color: ColorConstant.kColor7C7C7C,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (car.additionalInformation?.attentionGraber == null ||
                    car.additionalInformation!.attentionGraber!.isEmpty)
                  SizedBox(height: 10.h),
                Padding(
                  padding: getPadding(
                      left: 20.w, top: 5.h, right: 20.w, bottom: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: getPadding(
                            left: 8.w,
                            top: 5.h,
                            right: 8.w,
                            bottom: 5.h,
                          ),
                          margin: getMargin(right: 8.w),
                          decoration: AppDecoration
                              .gradientDeeporangeA200Yellow900
                              .copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder5,
                          ),
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: (car.fuelType?.name ?? notApplicable)
                                          .toUpperCase() +
                                      mileageOfVehicle,
                                  style: AppTextStyle.smallTextStyle.copyWith(
                                    color: ColorConstant.kColorWhite,
                                  ),
                                ),
                                TextSpan(
                                  text: '${currencyFormatter(car.mileage!)} '
                                      '${milesLabel.toUpperCase()}',
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
                      //more button
                      if (car.additionalInformation?.attentionGraber != null &&
                          car.additionalInformation!.attentionGraber!
                              .isNotEmpty)
                        InkWell(
                          onTap: () => customPopup(
                            content: DescriptionPopupWidget(car: car),
                          ),
                          child: Container(
                            padding: getPadding(
                              left: 8.w,
                              top: 5.h,
                              right: 8.w,
                              bottom: 5.h,
                            ),
                            decoration: AppDecoration.fillBlack900.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder5,
                            ),
                            child: Text(
                              moreButton,
                              style: AppTextStyle.smallTextStyle.copyWith(
                                color: ColorConstant.kColorWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void createChatGroup({required CarModel car, required int selectedIndex}) {
    String? userId;
    String? username;
    String? userImage;
    String? userType;
    num? rating;
    log('${currentUser?.userType}');
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
          routeName: CarProfileScreen.routeName,
          selectedIndex: selectedIndex,
        ));
  }
}
