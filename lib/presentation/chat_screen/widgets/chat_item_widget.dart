// ignore_for_file: must_be_immutable

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../core/configurations.dart';
import '../../../model/chat_model/chat_group/chat_group_model.dart';

class ChatItemWidget extends StatelessWidget {
  ChatItemWidget({
    required this.chatGroup,
    required this.onTap,
    required this.unreadWidget,
    required this.currentUserId,
    Key? key,
  }) : super(key: key);

  final ChatGroupModel chatGroup;
  final Widget unreadWidget;
  final VoidCallback onTap;
  final String currentUserId;
  num? rating;

  @override
  Widget build(BuildContext context) {
    if (chatGroup.carDetails?.userId == chatGroup.groupAdminUserId) {
      rating = chatGroup.admin?.rating;
    } else {
      rating = chatGroup.receiver?.rating;
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: getPadding(
          left: 11,
          right: 11,
          top: 13,
          bottom: 13,
        ),
        decoration: AppDecoration.outlineBlack9000c4.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder20,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CustomImageView(
                  url: chatGroup.carDetails?.carImage ?? '',
                  height: getVerticalSize(47),
                  width: getHorizontalSize(57),
                  radius: BorderRadius.circular(
                    getHorizontalSize(11),
                  ),
                  margin: getMargin(top: 2, bottom: 2),
                  fit: BoxFit.fill,
                ),
                if (chatGroup.mutedUsers.contains(currentUserId))
                  Container(
                    margin: getMargin(top: 2, bottom: 2),
                    height: getVerticalSize(47),
                    width: getHorizontalSize(57),
                    decoration: AppDecoration.outlineBlack9000c4.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: const Center(
                      child: CustomImageView(
                        svgPath: Assets.muteIcon,
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Padding(
                padding: getPadding(left: 12, bottom: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chatGroup.carDetails?.carName ?? '',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppTextStyle.txtPTSansBold14Bluegray900,
                              ),
                              Padding(
                                padding: getPadding(top: 1, bottom: 2),
                                child: Text(
                                  euro +
                                      currencyFormatter(
                                          chatGroup.carDetails?.carCash ?? 0),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.txtPTSansBold10.copyWith(
                                    fontSize: getFontSize(14),
                                  ),
                                ),
                              ),
                              Text(
                                chatGroup.groupAdminUserId! ==
                                        chatGroup.carDetails!.userId!
                                    ? chatGroup.admin?.userName ?? ''
                                    : chatGroup.receiver?.userName ?? '',
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppTextStyle.txtPTSansRegular10Gray600,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            unreadWidget,
                            const SizedBox(
                              height: 5,
                            ),
                            if (rating != null)
                              RatingBar.builder(
                                initialRating: rating!.toDouble(),
                                minRating: 1,
                                allowHalfRating: true,
                                itemSize: 15,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
