// ignore_for_file: must_be_immutable

import 'package:dotted_line/dotted_line.dart';

import '../../../core/configurations.dart';
import '../../../model/chat_model/chat_group/chat_group_model.dart';
import '../../../model/chat_model/user_chat_model/user_chat_model.dart';
import '../../common_widgets/custom_icon_button.dart';

class UserDealItem extends StatelessWidget {
  UserDealItem({
    Key? key,
    required this.chat,
    required this.chatGroup,
    required this.currentUserId,
  }) : super(key: key);
  final UserChatModel chat;
  final ChatGroupModel chatGroup;

  final String currentUserId;

  ///CAR OWNER
  String carOwnerName = '';
  String carOwnerId = '';
  String carOwnerImage = '';
  //CAR DEALER
  String carDealerName = '';
  String carDealerId = '';
  String carDealerImage = '';
  num? carDealerRating;

  bool isMyCar = false;
  String offerType = '';
  String offerTypeSvgIcon = '';
  String payType = '';

  ///chat profile image
  Widget circleAvatar(String userImage, {String? placeHolderAsset}) {
    return Container(
      height: 35,
      width: 35,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: FadeInImage(
        placeholder: AssetImage(placeHolderAsset ?? Assets.profilePic),
        imageErrorBuilder: (context, error, stackTrace) => Image.asset(
          placeHolderAsset ?? Assets.profilePic,
          fit: BoxFit.cover,
        ),
        image: NetworkImage(userImage),
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (chatGroup.carDetails?.userId == chatGroup.admin?.userId) {
      carOwnerName = chatGroup.admin?.userName ?? '';
      carOwnerId = chatGroup.admin?.userId ?? '';
      carOwnerImage = chatGroup.admin?.userImage ?? '';
      /******** DEALER *****/
      carDealerName = chatGroup.receiver?.userName ?? '';
      carDealerId = chatGroup.receiver?.userId ?? '';
      carDealerImage = chatGroup.receiver?.userImage ?? '';
      carDealerRating = chatGroup.receiver?.rating;
    } else {
      carOwnerName = chatGroup.receiver?.userName ?? '';
      carOwnerId = chatGroup.receiver?.userId ?? '';
      carOwnerImage = chatGroup.receiver?.userImage ?? '';
      /******** DEALER *****/
      carDealerName = chatGroup.admin?.userName ?? '';
      carDealerId = chatGroup.admin?.userId ?? '';
      carDealerImage = chatGroup.admin?.userImage ?? '';
      carDealerRating = chatGroup.admin?.rating;
    }
    if (currentUserId == chatGroup.carDetails?.userId) {
      isMyCar = true;
    }

    if (chat.payload?.offer?.offerType == convertEnumToString(OfferType.cash)) {
      offerType = cash.toUpperCase();
      offerTypeSvgIcon = Assets.imgCash;
    } else if (chat.payload?.offer?.offerType ==
        convertEnumToString(OfferType.swap)) {
      offerType = swap.toUpperCase();
      offerTypeSvgIcon = Assets.carLogo;
    } else {
      offerType = swapAndCash.toUpperCase();
      offerTypeSvgIcon = Assets.imgCarPlusCash;
      if (chat.createdUserId == currentUserId) {
        payType = chat.payload?.offer?.payType ?? '';
      } else {
        payType = chat.payload?.offer?.payType == payMe ? payYou : payMe;
      }
    }
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        // border: Border.all(color: ColorConstant.grey),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: getPadding(left: 17, top: 20, right: 17, bottom: 20),
                decoration: AppDecoration.outlineBlack9000c.copyWith(
                  borderRadius: BorderRadiusStyle.customBorderTL20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: getPadding(left: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          circleAvatar(carOwnerImage),
                          Padding(
                            padding: getPadding(left: 9, top: 2, bottom: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$carOwnerName${isMyCar ? ' (Me)' : ''}",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppTextStyle.txtPTSansBold12),
                                Padding(
                                  padding: getPadding(top: 1),
                                  child: Text(
                                    carOwnerId.toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppTextStyle.txtPTSansRegular10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: getPadding(top: 12, bottom: 12),
                            child: Text("CAR",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppTextStyle.txtPTSansBold10),
                          ),
                          CustomIconButton(
                            height: 37,
                            width: 37,
                            margin: getMargin(left: 7, right: 5),
                            variant: IconButtonVariant.OutlineBluegray100,
                            padding: IconButtonPadding.PaddingAll6,
                            child: const CustomImageView(
                              svgPath: Assets.carLogo,
                            ),
                          ),
                        ],
                      ),
                    ),
                    dottedDivider(),
                    Padding(
                      padding: getPadding(left: 7, top: 12, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          circleAvatar(chatGroup.carDetails?.carImage ?? ''),
                          Padding(
                            padding: getPadding(left: 10, bottom: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    (chatGroup.carDetails?.carName ?? '')
                                        .toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppTextStyle.txtPTSansRegular12Gray600),
                                Padding(
                                  padding: getPadding(top: 2),
                                  child: Text(
                                    (chatGroup.carDetails?.carModelName ?? '')
                                        .toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppTextStyle.txtPTSansBold10Bluegray900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: getPadding(bottom: 15, right: 15),
                            child: Text(
                              euro +
                                  currencyFormatter(
                                      chatGroup.carDetails?.carCash ?? 0),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppTextStyle.txtPTSansBold14Bluegray900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: getPadding(left: 25, top: 20, right: 17, bottom: 10),
                decoration: AppDecoration.outlineBlack9000c1
                    .copyWith(borderRadius: BorderRadiusStyle.customBorderBL20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        circleAvatar(carDealerImage),
                        Padding(
                          padding: getPadding(left: 9, top: 9, bottom: 11),
                          child: Text(
                            carDealerName.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppTextStyle.txtPTSansBold12Gray700,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: getPadding(left: 33, top: 12, bottom: 12),
                          child: Text(
                            offerType,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppTextStyle.txtPTSansBold10,
                          ),
                        ),
                        CustomIconButton(
                          height: 37,
                          width: 37,
                          margin: getMargin(left: 7, right: 5),
                          variant: IconButtonVariant.OutlineBluegray100,
                          padding: IconButtonPadding.PaddingAll6,
                          child: CustomImageView(
                            svgPath: offerTypeSvgIcon,
                          ),
                        ),
                      ],
                    ),
                    dottedDivider(),
                    if (chat.payload?.offer?.cars != null)
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, int index) {
                            final item = chat.payload!.offer!.cars![index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  circleAvatar(item.carImage ?? '',
                                      placeHolderAsset: Assets.imageNotFound),
                                  Padding(
                                    padding: getPadding(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text((item.carName ?? '').toUpperCase(),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppTextStyle
                                                .txtPTSansRegular12Gray600),
                                        Padding(
                                          padding: getPadding(top: 2),
                                          child: Text(
                                            (item.carModelName ?? '')
                                                .toUpperCase(),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppTextStyle
                                                .txtPTSansBold10Bluegray900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: getPadding(bottom: 15, right: 0),
                                    child: Text(
                                      euro +
                                          currencyFormatter(item.carCash ?? 0),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppTextStyle
                                          .txtPTSansBold14Bluegray900,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (_, int index) {
                            return dottedDivider();
                          },
                          itemCount: chat.payload!.offer!.cars!.length),
                    if (chat.payload?.offer?.offerType ==
                        convertEnumToString(OfferType.swapAndCash))
                      dottedDivider(),
                    if (chat.payload?.offer?.cash != null)
                      Padding(
                        padding: getPadding(top: 5),
                        child: Row(
                          children: [
                            const CustomIconButton(
                              height: 37,
                              width: 37,
                              variant: IconButtonVariant.OutlineBluegray100,
                              padding: IconButtonPadding.PaddingAll6,
                              child: CustomImageView(
                                svgPath: Assets.imgCash,
                              ),
                            ),
                            Padding(
                              padding: getPadding(left: 10),
                              child: Text(
                                chat.payload?.offer?.payType != null
                                    ? "Cash  ($payType)"
                                    : "Cash",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppTextStyle.txtPTSansRegular12Gray600,
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: getPadding(top: 9, bottom: 8, right: 15),
                              child: Text(
                                euro +
                                    currencyFormatter(
                                            chat.payload?.offer?.cash ?? 0)
                                        .toString(),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppTextStyle.txtPTSansBold14Bluegray900,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: getVerticalSize(120),
            left: getHorizontalSize(size.width / 4),
            child: GradientElevatedButton(
              width: 120,
              height: 40,
              onTap: () {},
              title: offerType,
              buttonGradient: LinearGradient(
                begin: const Alignment(
                  0.5,
                  0,
                ),
                end: const Alignment(
                  0.5,
                  1,
                ),
                colors: [
                  ColorConstant.pink700,
                  ColorConstant.pink900,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dottedDivider() {
    return Container(
      height: getVerticalSize(1.00),
      width: getHorizontalSize(262.00),
      margin: getMargin(left: 1, top: 13),
      child: const DottedLine(
        dashColor: Color(0xff7C7C7C),
      ),
    );
  }
}
