import 'package:wsac/bloc/faq/faq_bloc.dart';
import 'package:wsac/presentation/support_chat/support_chat_screen.dart';
import '../../core/configurations.dart';
import '../../model/faq/faq_model.dart';
import '../common_widgets/common_loader.dart';
import '../error_screen/error_widget.dart';

class FAQScreen extends StatefulWidget {
  static const String routeName = 'faq_screen';
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async =>
      BlocProvider.of<FaqBloc>(context).add(GetFaqQuestionsEvent());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: faqAppBar,
      body: Stack(
        children: [
          CustomImageView(
            svgPath: Assets.homeBackground,
            fit: BoxFit.fill,
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
          ),
          SafeArea(
              child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: Padding(
              padding: getPadding(
                top: 10,
                left: 25,
                right: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: getPadding(bottom: 20),
                    child: Text(
                      frequentlyAskedQns,
                      style: AppTextStyle.regularTextStyle
                          .copyWith(color: ColorConstant.kColorBlack),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<FaqBloc, FaqState>(
                      builder: (context, state) {
                        if (state is GetfaqQuestionsState) {
                          if (state.faqDataStatus == ProviderStatus.success) {
                            return ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.faqQuestionsList.length,
                                itemBuilder: (context, index) {
                                  return faqTileWidget(
                                      state.faqQuestionsList[index]);
                                },
                              ),
                            );
                          } else if (state.faqDataStatus ==
                              ProviderStatus.error) {
                            return Container(
                              alignment: Alignment.topCenter,
                              margin: getMargin(top: size.height * 0.15),
                              height: size.height,
                              child: ErrorWithButtonWidget(
                                message: errorOccurred,
                                buttonLabel: retryButton,
                                onTap: () async => await getData(),
                              ),
                            );
                          }
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return shimmerLoader(
                              Container(
                                height: getVerticalSize(51.h),
                                margin: getMargin(bottom: 10.h),
                                decoration: BoxDecoration(
                                  color: ColorConstant.kColorWhite,
                                  borderRadius: BorderRadius.circular(29.r),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 16.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            onTap: () => Navigator.pushNamed(
                                context, SupportChatScreen.routeName),
                            title: chatButton,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: GradientElevatedButton(
                            title: emailusButton,
                            onTap: () async =>
                                emailUs(subject: 'Ask your concern, Here'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget faqTileWidget(FaqModel faqItem) {
    return Padding(
      padding: getPadding(bottom: 10.h),
      child: ExpansionTile(
        tilePadding: getPadding(left: 15.w, right: 15.w),
        childrenPadding: getPadding(bottom: 20.h, left: 15.w, right: 15.w),
        title: Text(
          faqItem.question ?? '',
          style: AppTextStyle.regularTextStyle
              .copyWith(color: ColorConstant.kColor353333),
        ),
        textColor: ColorConstant.kColor353333,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusStyle.roundedBorder29),
        collapsedTextColor: ColorConstant.kColor7C7C7C,
        collapsedBackgroundColor: ColorConstant.kColorE4E4E4,
        collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadiusStyle.roundedBorder29),
        backgroundColor: Colors.white,
        collapsedIconColor: ColorConstant.kColor353333,
        iconColor: ColorConstant.kColor353333,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              faqItem.answer ?? '',
              style: AppTextStyle.regularTextStyle
                  .copyWith(color: ColorConstant.kColor7C7C7C),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
