import 'package:enum_to_string/enum_to_string.dart';

import '../../../bloc/my_cars/my_cars_bloc.dart';
import '../../../bloc/subscription/subscription_bloc.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../core/configurations.dart';
import '../../../model/user/user_model.dart';
import '../../common_widgets/common_admin_support_button.dart';
import 'my_subscription_tabs/dealer_account.dart';
import 'my_subscription_tabs/premium_post.dart';

class MySubscriptionPage extends StatefulWidget {
  static const String routeName = "my_subscription_page";
  const MySubscriptionPage({
    super.key,
    required this.initialIndex,
  });

  final int initialIndex;

  @override
  State<MySubscriptionPage> createState() => _MySubscriptionPageState();
}

class _MySubscriptionPageState extends State<MySubscriptionPage>
    with TickerProviderStateMixin {
  UserModel? currentUser;
  UserType? userType;
  late TabController _tabController;
  late SubscriptionBloc subscriptionBloc;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: widget.initialIndex,
      length: 2,
      vsync: this,
    );
    currentUser = context.read<UserBloc>().currentUser;
    userType =
        EnumToString.fromString(UserType.values, currentUser?.userType ?? '');
    super.initState();
  }

  Future<bool> _onBackPress() async {
    //to refresh my cars state
    BlocProvider.of<MyCarsBloc>(context).add(const GetMyCarsEvent(
        fetchMyCarjson: {
          'pageNo': 0,
          'perPage': 10,
          "filters": <String, dynamic>{}
        }));
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: CustomScaffold(
        title: subscriptionAppBar,
        backWidget: ModalRoute.of(context)!.canPop
            ? IconButton(
                onPressed: _onBackPress,
                icon: const CustomImageView(
                  svgPath: Assets.backArrow,
                ),
              )
            : null,
        actions: const [
          AdminSupportButton(),
        ],
        body: Stack(
          children: [
            CustomImageView(
              imagePath: Assets.redMountainWithWhite,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
            ),
            userType == UserType.private
                ? const SubscriptionPremiumPostTab()
                : Column(
                    children: [
                      Container(
                        width: size.width / 1.15,
                        height: 40.h,
                        margin: getMargin(bottom: 10.h),
                        decoration: BoxDecoration(
                          color: ColorConstant.black900,
                          borderRadius: BorderRadius.circular(
                            getHorizontalSize(100.r),
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: ColorConstant.whiteA700,
                          unselectedLabelColor: ColorConstant.whiteA700,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.r),
                            gradient: LinearGradient(
                              colors: kPrimaryGradientColor,
                            ),
                          ),
                          onTap: (value) {},
                          tabs: const [
                            Tab(text: dealerTabTitle),
                            Tab(text: premiumPostTabTitle),
                          ],
                          labelStyle: AppTextStyle.regularTextStyle
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: const [
                            SubscriptionDealerAccountTab(
                                subscriptionPageName:
                                    SubscriptionPageName.mySubscription),
                            SubscriptionPremiumPostTab(),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h)
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
