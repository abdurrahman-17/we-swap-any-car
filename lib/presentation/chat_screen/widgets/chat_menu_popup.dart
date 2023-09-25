import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../repository/chat_repo.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/common_popups.dart';
import '../../report_an_issue/report_an_issue_screen.dart';

class ChatMenuDialog extends StatelessWidget {
  const ChatMenuDialog({
    super.key,
    required this.groupId,
    required this.userIdOrAdminUserId,
    required this.groupUsers,
  });

  final String groupId;
  final String userIdOrAdminUserId;
  final List<dynamic> groupUsers;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.fillGray100.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder29,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///REPORT USER
          InkWell(
            onTap: () async {
              final navigation = Navigator.of(context);
              bool result = await confirmationPopup(
                messageTextAlign: TextAlign.center,
                title: confirmTitle,
                message: reportUserConfirm,
                isQuestion: true,
              );
              if (result) {
                navigation.pushNamed(
                  ReportAnIssueScreen.routeName,
                );
              }
            },
            child: Padding(
              padding:
                  getPadding(top: 20.h, left: 20.w, bottom: 10.h, right: 20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      reportUser,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansRegular16Gray600,
                    ),
                  ),
                  CustomImageView(
                    color: ColorConstant.gray600,
                    svgPath: Assets.reportUserLogo,
                    height: getSize(18),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            indent: 10,
            endIndent: 10,
          ),

          ///BLOCK
          InkWell(
            onTap: () async {
              final navigator = Navigator.of(context);
              bool result = await confirmationPopup(
                messageTextAlign: TextAlign.center,
                title: confirmTitle,
                message: blockUserConfirm,
                isQuestion: true,
              );

              if (result) {
                progressDialogue();
                bool isDone = await Locator.instance.get<ChatRepo>().blockChat(
                    userId: userIdOrAdminUserId,
                    groupId: groupId,
                    oppositeUserId: groupUsers[0] == userIdOrAdminUserId
                        ? "${groupUsers[1]}"
                        : "${groupUsers[0]}");
                if (isDone) {
                  navigator.popUntil((route) => route.isFirst);
                }
              }
            },
            child: Padding(
              padding:
                  getPadding(bottom: 10.h, left: 20.w, right: 20.w, top: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      blockUser,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansRegular16Red300,
                    ),
                  ),
                  const CustomImageView(
                    svgPath: Assets.blockUserLogo,
                    fit: BoxFit.scaleDown,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            indent: 10,
            endIndent: 10,
          ),

          ///DELETE
          InkWell(
            onTap: () async {
              final navigator = Navigator.of(context);
              bool result = await confirmationPopup(
                messageTextAlign: TextAlign.center,
                title: confirmTitle,
                message: deleteChatConfirm,
                isQuestion: true,
              );
              if (result) {
                bool isDone = await Locator.instance
                    .get<ChatRepo>()
                    .deleteChat(userId: userIdOrAdminUserId, groupId: groupId);
                if (isDone) {
                  navigator.popUntil((route) => route.isFirst);
                }
              }
            },
            child: Padding(
              padding:
                  getPadding(bottom: 20.h, left: 20.w, top: 10.h, right: 20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      deleteChat,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppTextStyle.txtPTSansRegular16Gray600,
                    ),
                  ),
                  const CustomImageView(
                    svgPath: Assets.deleteChatLogo,
                    fit: BoxFit.scaleDown,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
