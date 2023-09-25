import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/app_decoration.dart';
import '../../../utility/colors.dart';
import '../../../utility/size_utils.dart';
import '../../../utility/styles.dart';
import '../../common_widgets/common_popups.dart';
import '../../common_widgets/custom_image_view.dart';
import 'chat_menu_popup.dart';

class SelectedCarItemWidget extends StatelessWidget {
  const SelectedCarItemWidget({
    super.key,
    required this.groupId,
    required this.userIdOrAdminUserId,
    required this.rating,
    required this.userName,
    required this.carImage,
    required this.carName,
    required this.groupUsers,
  });
  final String groupId;
  final String userIdOrAdminUserId;
  final String userName;
  final String carImage;
  final String carName;
  final num? rating;
  final List<dynamic> groupUsers;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Container(
        padding: getPadding(all: 11),
        decoration: AppDecoration.outlineBlack9000c4
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder20),
        child: Row(
          children: [
            CustomImageView(
              url: carImage,
              height: getVerticalSize(47),
              width: getHorizontalSize(57),
              radius: BorderRadius.circular(
                getHorizontalSize(11),
              ),
            ),
            Padding(
              padding: getPadding(left: 12, top: 4, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carName.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppTextStyle.txtPTSansBold14Bluegray900,
                  ),
                  Padding(
                    padding: getPadding(top: 5, bottom: 5),
                    child: Text(
                      userName,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansBold10,
                    ),
                  ),
                  if (rating != null)
                    RatingBar.builder(
                      initialRating: rating!.toDouble(),
                      minRating: 1,
                      allowHalfRating: true,
                      itemSize: 15,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
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
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                showDialogue(
                  child: ChatMenuDialog(
                    userIdOrAdminUserId: userIdOrAdminUserId,
                    groupId: groupId,
                    groupUsers: groupUsers,
                  ),
                );
              },
              icon: Icon(
                Icons.more_vert_rounded,
                color: ColorConstant.kColor7C7C7C,
              ),
            )
          ],
        ),
      ),
    );
  }
}
