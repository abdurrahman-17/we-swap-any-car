import '../../core/configurations.dart';
import '../../bloc/avatar/avatar_bloc.dart';
import '../common_widgets/common_admin_support_button.dart';
import '../common_widgets/common_divider.dart';
import 'widgets/gridtrash_item_widget.dart';

class SelectProfileAvatarScreen extends StatefulWidget {
  static const String routeName = 'select_profile_avatar_screen';
  const SelectProfileAvatarScreen({super.key});

  @override
  State<SelectProfileAvatarScreen> createState() =>
      _SelectProfileAvatarScreenState();
}

class _SelectProfileAvatarScreenState extends State<SelectProfileAvatarScreen> {
  String? selectedImageUrl;

  @override
  void initState() {
    BlocProvider.of<AvatarBloc>(context).add(AvatarInitialEvent());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      BlocProvider.of<AvatarBloc>(context).add(GetProfileAvatars());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: selectAvatarAppBar,
      actions: const [
        AdminSupportButton(),
      ],
      body: Stack(
        children: [
          CustomImageView(
            svgPath: Assets.homeBackground,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 0.h),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: 30.h,
                            ),
                            child: Stack(
                              children: [
                                Container(
                                    height: getSize(87),
                                    width: getSize(87),
                                    decoration: AppDecoration
                                        .kGradientBoxDecoration
                                        .copyWith(
                                            borderRadius: BorderRadiusStyle
                                                .circleBorder100),
                                    child: selectedImageUrl != null
                                        ? CustomImageView(
                                            url: selectedImageUrl,
                                            fit: BoxFit.fill,
                                            height: getSize(87),
                                            width: getSize(87),
                                            radius:
                                                BorderRadius.circular(100.r),
                                          )
                                        : null),
                                selectedImageUrl == null
                                    ? Positioned.fill(
                                        child: IconButton(
                                          alignment: Alignment.center,
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.camera_alt_outlined,
                                            color: ColorConstant.kColorWhite,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),

                        const GradientDivider(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Text(
                            msgChooseYourAvatar,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppTextStyle.txtPTSansRegular14Bluegray900,
                          ),
                        ),

                        ///BIT EMOJI
                        BlocBuilder<AvatarBloc, AvatarState>(
                          builder: (context, state) {
                            if (state is UserAvatarSuccessState) {
                              final variationList =
                                  state.avatarVariationResponse;
                              return Padding(
                                padding: getPadding(top: 27),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: getVerticalSize(100),
                                    crossAxisCount: 3,
                                    mainAxisSpacing: getVerticalSize(18),
                                    crossAxisSpacing: getHorizontalSize(18),
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: variationList.length,
                                  itemBuilder: (context, index) {
                                    return AvatarVariationItemWidget(
                                      url: variationList[index].url,
                                      selectedImageUrl: selectedImageUrl,
                                      onTapVariation: () => setState(
                                        () => selectedImageUrl =
                                            variationList[index].url,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return Padding(
                              padding: getPadding(top: 27),
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: getVerticalSize(100),
                                  crossAxisCount: 3,
                                  mainAxisSpacing: getVerticalSize(18),
                                  crossAxisSpacing: getHorizontalSize(18),
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemCount: 3,
                                itemBuilder: (context, index) {
                                  return const AvatarVariationItemWidget(
                                    isLoading: true,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  CustomElevatedButton(
                    title: saveButton,
                    onTap: () {
                      if (selectedImageUrl != null) {
                        Navigator.pop(context, selectedImageUrl);
                      } else {
                        showSnackBar(message: 'Please choose an avatar');
                      }
                    },
                  ),
                  SizedBox(height: 15.h)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
