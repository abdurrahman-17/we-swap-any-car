import 'package:easy_refresh/easy_refresh.dart';
import 'package:wsac/bloc/my_matches_data/my_matches_bloc.dart';
import 'package:wsac/core/configurations.dart';
import 'package:wsac/presentation/common_widgets/custom_text_widget.dart';
import 'package:wsac/presentation/my_matches/widget/my_match_deal_item.dart';

import '../../bloc/user/user_bloc.dart';
import '../../model/my_matches/my_matches_model.dart';
import '../../model/user/user_model.dart';
import '../common_widgets/common_loader.dart';
import '../error_screen/error_widget.dart';

class MyMatches extends StatefulWidget {
  static const String routeName = 'my_matches_screen';
  const MyMatches({super.key});
  @override
  State<MyMatches> createState() => _MyMatchesState();
}

class _MyMatchesState extends State<MyMatches> {
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  UserModel? currentUserData;
  int pageNo = 0;
  List<MyMatchModel> myMatches = [];

  @override
  void initState() {
    super.initState();
    currentUserData = context.read<UserBloc>().currentUser;
    getMyMatches();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future<void> getMyMatches() async {
    BlocProvider.of<MyMatchesBloc>(context).add(GetMyMatchesEvent(
      pageNo: 0,
      userId: currentUserData?.userId ?? '',
      // userId: '64d610dfd1d6e1291a57a203',
    ));
  }

  Future<void> getLoadMoreMatches() async {
    context.read<MyMatchesBloc>().add(GetMoreMyMatchesEvent(
          pageNo: ++pageNo,
          userId: currentUserData?.userId ?? '',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: myMatchScreenAppBar,
      body: Stack(
        children: [
          CustomImageView(
            svgPath: Assets.homeBackground,
            fit: BoxFit.fill,
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
          ),
          BlocConsumer<MyMatchesBloc, MyMatchesState>(
              listener: (context, state) {
            if (state is GetMoreMyMatchesState) {
              if (state.myMoreMatchesStatus == ProviderStatus.success) {
                if (state.myMoreMatchesResponse?.myMatchesList != null &&
                    state.myMoreMatchesResponse!.myMatchesList!.isNotEmpty) {
                  myMatches
                      .addAll(state.myMoreMatchesResponse?.myMatchesList ?? []);
                  _easyRefreshController.finishLoad(
                      IndicatorResult.success, true);
                } else {
                  _easyRefreshController.finishLoad(
                      IndicatorResult.noMore, true);
                }
              }
            }
          }, builder: (context, state) {
            if (state is GetMyMatchesState) {
              if (state.myMatchesStatus == ProviderStatus.success) {
                myMatches.addAll(state.myMatchesResponse?.myMatchesList ?? []);
                return myMatchesWidget(myMatches);
              } else if (state.myMatchesStatus == ProviderStatus.error) {
                return Container(
                  alignment: Alignment.topCenter,
                  margin: getMargin(top: size.height * 0.15),
                  height: size.height,
                  child: ErrorWithButtonWidget(
                    message: errorOccurred,
                    buttonLabel: retryButton,
                    onTap: () async => await getMyMatches(),
                  ),
                );
              }
            } else if (state is GetMoreMyMatchesState) {
              return myMatchesWidget(myMatches);
            }
            return shimmerList();
          }),
        ],
      ),
    );
  }

  Widget shimmerList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: getPadding(left: 25.w, right: 25.w, bottom: 25.h),
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return shimmerLoader(
          Container(
            height: 250,
            margin: getMargin(top: 21.h),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: ColorConstant.kColorWhite,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        );
      },
    );
  }

  Widget myMatchesWidget(List<MyMatchModel> myMatchesList) {
    return myMatchesList.isNotEmpty
        ? ScrollConfiguration(
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
              onLoad: () => getLoadMoreMatches(),
              child: ListView.separated(
                padding: getPadding(
                  left: 25.w,
                  right: 25.w,
                  bottom: 25.h,
                  top: 10.h,
                ),
                shrinkWrap: true,
                itemCount: myMatchesList.length,
                itemBuilder: (context, index) =>
                    MyMatchDealItem(myMatch: myMatchesList[index]),
                separatorBuilder: (context, index) => SizedBox(height: 21.h),
              ),
            ),
          )
        : const CenterText(text: 'No Matches available');
  }
}
