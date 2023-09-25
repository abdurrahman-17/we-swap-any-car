import '../../../core/configurations.dart';
import '../../../core/locator.dart';
import '../../../model/chat_model/user_chat_model/user_chat_model.dart';
import '../../../repository/chat_repo.dart';

class UnreadWidget extends StatelessWidget {
  const UnreadWidget(
      {super.key, required this.groupId, required this.userIdOrAdminUserId});

  final String groupId;
  final String userIdOrAdminUserId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserChatModel>>(
      stream: Locator.instance.get<ChatRepo>().getUnreadCount(
            groupId: groupId,
            userId: userIdOrAdminUserId,
          ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final tempList = snapshot.data ?? [];
          final int unreadCount = tempList
              .where((element) => element.readUsers.isEmpty)
              .toList()
              .length;
          return Opacity(
            opacity: unreadCount == 0 ? 0 : 1,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: kPrimaryGradientColor),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  unreadCount.toString(),
                  style: AppTextStyle.regularTextStyle,
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
