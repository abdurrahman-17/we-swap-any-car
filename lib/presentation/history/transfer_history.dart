import 'package:wsac/bloc/history/history_bloc.dart';
import 'package:wsac/presentation/history/widgets/user_deal_item_history.dart';
import '../../../core/configurations.dart';
import '../common_widgets/common_admin_support_button.dart';
import '../common_widgets/common_loader.dart';

class TransferHistory extends StatefulWidget {
  static const String routeName = "transfer_history";

  const TransferHistory({Key? key}) : super(key: key);

  @override
  State<TransferHistory> createState() => _TransferHistoryState();
}

class _TransferHistoryState extends State<TransferHistory> {
  final TextEditingController filterController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  late int selectedFilterOption = 0;
  bool isGuest = false;

  @override
  void initState() {
    super.initState();
    delayedStart(() {
      BlocProvider.of<HistoryBloc>(context)
          .add(GetHistoryDataEvent(historyModel: historyModelData));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: ColorConstant.kBackgroundColor,
      title: historyAppBar,
      actions: const [
        AdminSupportButton(),
      ],
      body: Stack(
        children: [
          CustomImageView(
            alignment: Alignment.bottomCenter,
            svgPath: Assets.homeBackground,
            width: size.width,
            fit: BoxFit.fitWidth,
          ),
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonDropDown(
                            hintText: filterByLabel,
                            items: offersTypesSelctableList,
                            validatorMsg: '*Required',
                            onChanged: (value) {
                              if (value?.id != null) {
                                setState(() => selectedFilterOption =
                                    int.parse(value!.id!));
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: CommonTextFormField(
                              cursorHgt: 21,
                              controller: searchController,
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.name,
                              autoValidate: AutovalidateMode.disabled,
                              suffixIcon: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomImageView(
                                    onTap: () {},
                                    imagePath: Assets.imgSwitchHead,
                                    height: getSize(35.00),
                                    width: getSize(35.00),
                                    radius: BorderRadiusStyle.txtCircleBorder21,
                                  ),
                                  Icon(
                                    Icons.search_rounded,
                                    color: ColorConstant.gray100,
                                    size: 22,
                                  )
                                ],
                              ),
                            ),
                          ),
                          BlocBuilder<HistoryBloc, HistoryState>(
                            builder: (context, state) {
                              if (state is GetHistoryDataState) {
                                return ListView.builder(
                                  physics: const PageScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.historyModel!.data!.length,
                                  itemBuilder: (ctx, int index) {
                                    if (state.historyModel!.data![index]
                                            .transactionMethod ==
                                        cash) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: getPadding(
                                                top: 20.h, left: 5.w),
                                            child: Text(
                                              carDate,
                                              style: AppTextStyle
                                                  .txtSansRegular12Bluegray900,
                                            ),
                                          ),
                                          UserDealItemHistory(
                                            onTap: () {},
                                            margin: getMargin(top: 27),
                                            isCar: false,
                                            isCash: true,
                                            btnTitle: state.historyModel!
                                                .data![index].transactionMethod!
                                                .toUpperCase(),
                                            textTitle: state.historyModel!
                                                .data![index].transactionMethod!
                                                .toUpperCase(),
                                            userName: state.historyModel!
                                                .data![index].userName!,
                                            userPicture: state.historyModel!
                                                .data![index].userPicture!,
                                            carPicture: state.historyModel!
                                                .data![index].carPicture!,
                                            carValue: state.historyModel!
                                                .data![index].carValue!,
                                            carName: state.historyModel!
                                                .data![index].carName!,
                                            carModel: state.historyModel!
                                                .data![index].carModel!,
                                            traderName: state.historyModel!
                                                .data![index].traderName!,
                                          ),
                                        ],
                                      );
                                    } else if (state.historyModel!.data![index]
                                            .transactionMethod ==
                                        swap) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: getPadding(
                                                top: 20.h, left: 5.w),
                                            child: Text(
                                              carDate,
                                              style: AppTextStyle
                                                  .txtSansRegular12Bluegray900,
                                            ),
                                          ),
                                          UserDealItemHistory(
                                            onTap: () {},
                                            margin: getMargin(top: 27),
                                            isCar: true,
                                            isCash: false,
                                            btnTitle: state.historyModel!
                                                .data![index].transactionMethod!
                                                .toUpperCase(),
                                            textTitle: state.historyModel!
                                                .data![index].transactionMethod!
                                                .toUpperCase(),
                                            userName: state.historyModel!
                                                .data![index].userName!,
                                            userPicture: state.historyModel!
                                                .data![index].userPicture!,
                                            carPicture: state.historyModel!
                                                .data![index].carPicture!,
                                            carValue: state.historyModel!
                                                .data![index].carValue!,
                                            carName: state.historyModel!
                                                .data![index].carName!,
                                            carModel: state.historyModel!
                                                .data![index].carModel!,
                                            traderName: state.historyModel!
                                                .data![index].traderName!,
                                          ),
                                        ],
                                      );
                                    } else if (state.historyModel!.data![index]
                                            .transactionMethod ==
                                        swapAndCash) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: getPadding(
                                                top: 20.h, left: 5.w),
                                            child: Text(
                                              carDate,
                                              style: AppTextStyle
                                                  .txtSansRegular12Bluegray900,
                                            ),
                                          ),
                                          UserDealItemHistory(
                                            onTap: () {},
                                            margin: getMargin(top: 27),
                                            isCar: true,
                                            isCash: true,
                                            btnTitle: state.historyModel!
                                                .data![index].transactionMethod!
                                                .toUpperCase(),
                                            textTitle: state.historyModel!
                                                .data![index].transactionMethod!
                                                .toUpperCase(),
                                            userName: state.historyModel!
                                                .data![index].userName!,
                                            userPicture: state.historyModel!
                                                .data![index].userPicture!,
                                            carPicture: state.historyModel!
                                                .data![index].carPicture!,
                                            carValue: state.historyModel!
                                                .data![index].carValue!,
                                            carName: state.historyModel!
                                                .data![index].carName!,
                                            carModel: state.historyModel!
                                                .data![index].carModel!,
                                            traderName: state.historyModel!
                                                .data![index].traderName!,
                                          ),
                                        ],
                                      );
                                    }
                                    return null;
                                  },
                                );
                              }
                              return ListView.builder(
                                physics: const PageScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: 3,
                                itemBuilder: (BuildContext context, int index) {
                                  return shimmerLoader(
                                    Container(
                                      height: 200,
                                      margin: getMargin(top: 27),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: ColorConstant.kColorWhite,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ]),
                  )
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
